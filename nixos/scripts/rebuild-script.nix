# nixos/scripts/rebuild-script.nix
{ pkgs }:

pkgs.writeScriptBin "nr" ''
  #!/usr/bin/env bash
  set -euo pipefail
  IFS=$'\n\t'

  CONFIG_DIR="/home/utyara3/nixos-config"
  ACTION="''${1:-switch}"
  shift || true          # остальные аргументы пробросим в nh (--flake .#host и т.п.)

  # --- цвета ---
  if [ -t 2 ]; then
    RED=$'\e[31m'; YEL=$'\e[33m'; GRN=$'\e[32m'; BLU=$'\e[34m'; RST=$'\e[0m'
  else
    RED= YEL= GRN= BLU= RST=
  fi
  die()  { echo "''${RED}Error:''${RST} $*"  >&2; exit 1; }
  info() { echo "''${BLU}==>''${RST} $*"     >&2; }
  warn() { echo "''${YEL}Warning:''${RST} $*" >&2; }

  case "$ACTION" in
    switch|boot|test|build|dry-activate|rollback) ;;
    *) die "Invalid action '$ACTION'. Options: switch, boot, test, build, dry-activate, rollback" ;;
  esac

  [ -d "$CONFIG_DIR" ] || die "Directory $CONFIG_DIR not found."
  cd "$CONFIG_DIR"
  export FLAKE="$CONFIG_DIR"

  # --- хелперы ---
  get_current_gen() {
    local target
    target=$(readlink -f /nix/var/nix/profiles/system 2>/dev/null) || return 1
    [[ "$target" =~ system-([0-9]+)-link ]] && echo "''${BASH_REMATCH[1]}"
  }
  in_git()  { git rev-parse --is-inside-work-tree &>/dev/null; }
  has_changes() { ! git diff --cached --quiet || ! git diff --quiet; }

  # --- проверки репозитория ---
  IS_GIT=false
  if in_git; then
    IS_GIT=true
    git ls-files --unmerged | grep -q '^' && die "Unresolved merge conflicts detected."
    [ -n "$(git status --porcelain)" ] && warn "Uncommitted changes present before rebuild."
  else
    warn "Not a Git repository. Auto-commit disabled."
  fi

  # --- форматирование (не глотаем ошибки) ---
  if command -v nix &>/dev/null; then
    info "Running formatter..."
    nix fmt . || warn "Formatter failed or nothing to format."
  fi

  # --- stage для flake ---
  if [ "$IS_GIT" = true ]; then
    # ВНИМАНИЕ: git add -A стейджит всё, включая возможные секреты.
    # Держите .gitignore в порядке.
    git add -A
    has_changes && { info "Staged configuration changes:"; git status --short; }
  fi

  # --- запоминаем поколение ДО сборки ---
  PREV_GEN=$(get_current_gen || true)
  info "Current generation: ''${PREV_GEN:-unknown}"

  # --- сам rebuild ---
  info "Executing: nh os $ACTION $*"
  if ! nh os "$ACTION" "$@"; then
    die "NixOS rebuild failed. Changes aborted."
  fi

  # --- пост-обработка только для реальных деплоев ---
  case "$ACTION" in
    switch|boot)
      NEW_GEN=$(get_current_gen || true)

      # diff пакетов + сохранение для тела коммита
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

      # авто-коммит
      if [ "$IS_GIT" = true ] && has_changes; then
        # Номер ребилда = номер поколения
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
            info "Committed: $COMMIT_MSG"
          else
            warn "Auto-commit failed (hooks/signing?). Changes left staged."
          fi
        else
          if git commit -m "$COMMIT_MSG"; then
            info "Committed: $COMMIT_MSG"
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
