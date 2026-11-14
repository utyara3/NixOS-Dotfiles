# nixos/scripts/rebuild-script.nix
{ pkgs }:

let
  jq = "${pkgs.jq}/bin/jq";
in
pkgs.writeScriptBin "nr" ''
  #!/usr/bin/env bash
  set -euo pipefail
  IFS=$'\n\t'

  JQ="${jq}"

  CONFIG_DIR="/home/utyara3/nixos-config"
  ACTION="''${1:-switch}"
  shift || true

  if [ -t 2 ]; then
    RED=$'\e[31m'; YEL=$'\e[33m'; GRN=$'\e[32m'; BLU=$'\e[34m'; RST=$'\e[0m'
  else
    RED=; YEL=; GRN=; BLU=; RST=
  fi
  die()  { echo "''${RED}Error:''${RST} $*"   >&2; exit 1; }
  info() { echo "''${BLU}==>''${RST} $*"      >&2; }
  warn() { echo "''${YEL}Warning:''${RST} $*" >&2; }
  ok()   { echo "''${GRN}✓''${RST} $*"        >&2; }

  case "$ACTION" in
    switch|boot|test|build|dry-activate) ;;
    *) die "Invalid action '$ACTION'. Options: switch, boot, test, build, dry-activate" ;;
  esac

  [ -d "$CONFIG_DIR" ] || die "Directory $CONFIG_DIR not found."
  cd "$CONFIG_DIR"
  export FLAKE="$CONFIG_DIR"

  # --- generation detection: 3 уровня fallback ---
  # 1) readlink (без -f!) — работает всегда, systemd сам его читает
  # 2) list-generations --json + jq из store
  # 3) list-generations plaintext — звёздочка склеена с номером (284*)
  get_current_gen() {
    local gen link

    link=$(readlink /nix/var/nix/profiles/system 2>/dev/null || true)
    if [[ "$link" =~ system-([0-9]+)-link ]]; then
      echo "''${BASH_REMATCH[1]}"; return 0
    fi

    if [ -x "$JQ" ] && command -v nixos-rebuild &>/dev/null; then
      gen=$(nixos-rebuild list-generations --json 2>/dev/null \
        | "$JQ" -r '.[] | select(.current == true) | .generation' 2>/dev/null || true)
      if [[ "$gen" =~ ^[0-9]+$ ]]; then echo "$gen"; return 0; fi
    fi

    if command -v nixos-rebuild &>/dev/null; then
      # $1 == "284*" для текущего; снимаем звёздочку
      gen=$(nixos-rebuild list-generations 2>/dev/null \
        | awk '/\*/ && $1 ~ /^[0-9]/ { sub(/\*/, "", $1); print $1; exit }' || true)
      if [[ "$gen" =~ ^[0-9]+$ ]]; then echo "$gen"; return 0; fi
    fi

    return 1
  }

  in_git()      { git rev-parse --is-inside-work-tree &>/dev/null; }
  has_changes() { ! git diff --cached --quiet || ! git diff --quiet; }

  # --- проверки репозитория ---
  IS_GIT=false
  if in_git; then
    IS_GIT=true
    if git ls-files --unmerged | grep -q '^'; then
      die "Unresolved merge conflicts detected."
    fi
    if [ -n "$(git status --porcelain)" ]; then
      warn "Uncommitted changes present before rebuild."
    fi
  else
    warn "Not a Git repository. Auto-commit disabled."
  fi

  # --- форматтер ---
  # `nix fmt` без аргументов виснет (nixfmt читает stdin).
  # `nix fmt .` работает, но пишет deprecation warning — подавляем.
  # timeout — страховка от зависания.
  # Долгосрочно: добавьте в flake.nix formatter.<system> = pkgs.nixfmt-tree;
  if command -v nix &>/dev/null; then
    info "Running formatter..."
    if ! timeout 60 nix fmt . >/dev/null 2>&1; then
      warn "Formatter failed or timed out."
    fi
  fi

  # --- stage для flake ---
  if [ "$IS_GIT" = true ]; then
    git add -A
    if has_changes; then
      info "Staged configuration changes:"
      git status --short
    fi
  fi

  # --- запоминаем поколение ДО сборки ---
  PREV_GEN=$(get_current_gen || true)
  if [ -n "''${PREV_GEN:-}" ]; then
    info "Current generation: $PREV_GEN"
  else
    warn "Could not determine current generation."
  fi

  # --- сам rebuild ---
  info "Executing: nh os $ACTION $*"
  if ! nh os "$ACTION" "$@"; then
    die "NixOS rebuild failed. Changes aborted."
  fi

  # --- пост-обработка ---
  case "$ACTION" in
    switch|boot)
      NEW_GEN=$(get_current_gen || true)

      NVD_OUT=""
      if [ -n "''${PREV_GEN:-}" ] && [ -n "''${NEW_GEN:-}" ] \
         && [ "$PREV_GEN" != "$NEW_GEN" ] \
         && command -v nvd &>/dev/null; then
        info "Package diff (gen $PREV_GEN → $NEW_GEN):"
        NVD_OUT=$(nvd diff \
          "/nix/var/nix/profiles/system-''${PREV_GEN}-link" \
          "/nix/var/nix/profiles/system-''${NEW_GEN}-link" 2>&1 || true)
        echo "$NVD_OUT"
      fi

      if [ "$IS_GIT" = true ] && has_changes; then
        REBUILD_NO=""
        if   [ -n "''${NEW_GEN:-}" ];  then REBUILD_NO="$NEW_GEN"
        elif [ -n "''${PREV_GEN:-}" ]; then REBUILD_NO=$(( PREV_GEN + 1 ))
        fi

        if [ -n "$REBUILD_NO" ]; then
          COMMIT_MSG="nixos: rebuild #$REBUILD_NO ($ACTION) — $(date '+%Y-%m-%d %H:%M')"
        else
          COMMIT_MSG="nixos: $ACTION ($(date '+%Y-%m-%d %H:%M'))"
        fi

        if [ -n "$NVD_OUT" ]; then
          if git commit -m "$COMMIT_MSG" -m "$NVD_OUT"; then
            ok "Committed: $COMMIT_MSG"
          else
            warn "Auto-commit failed (hooks/signing?). Changes left staged."
          fi
        else
          if git commit -m "$COMMIT_MSG"; then
            ok "Committed: $COMMIT_MSG"
          else
            warn "Auto-commit failed (hooks/signing?). Changes left staged."
          fi
        fi
      else
        info "No configuration changes detected. Skipping commit."
      fi
      ;;
    *)
      info "Action '$ACTION' does not create a new generation; skipping commit."
      ;;
  esac
''
