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

  # ---- visual -------------------------------------------------------
  if [ -t 2 ]; then
    RESET=$'\e[0m'; BOLD=$'\e[1m'; DIM=$'\e[2m'
    RED=$'\e[31m'; GRN=$'\e[32m'; YEL=$'\e[33m'; BLU=$'\e[34m'; CYN=$'\e[36m'
  else
    RESET=; BOLD=; DIM=; RED=; GRN=; YEL=; BLU=; CYN=
  fi
  W=66
  hr()   { printf '%s\n' "''${DIM}$(printf '─%.0s' $(seq 1 $W))''${RESET}" >&2; }
  step() {
    local n="$1" title="$2"
    local prefix="[$n/5] $title"
    local pad=$(( W - 4 - ''${#prefix} )); [ $pad -lt 3 ] && pad=3
    printf '\n%s\n' "''${BOLD}''${BLU}── $prefix ''${DIM}$(printf '─%.0s' $(seq 1 $pad))''${RESET}" >&2
  }
  kv()   {
    local k="$1" v="$2" c="''${3:-$RESET}"
    printf '  %s%-18s%s %s%s%s\n' "$DIM" "$k" "$RESET" "$c" "$v" "$RESET" >&2
  }
  ok()   { printf '  %s[ ok ]%s %s\n' "$GRN" "$RESET" "$*" >&2; }
  info() { printf '  %s[info]%s %s\n' "$BLU" "$RESET" "$*" >&2; }
  warn() { printf '  %s[warn]%s %s\n' "$YEL" "$RESET" "$*" >&2; }
  fail() { printf '  %s[fail]%s %s\n' "$RED" "$RESET" "$*" >&2; }
  die()  { printf '\n%s[fail]%s %s\n\n' "$RED" "$RESET" "$*" >&2; exit 1; }
  fmt_time() {
    local s=$1
    if [ "$s" -ge 60 ]; then printf '%dm %ds' $(( s / 60 )) $(( s % 60 ))
    else printf '%ds' "$s"; fi
  }

  # ---- validate -----------------------------------------------------
  case "$ACTION" in
    switch|boot|test|build|dry-activate) ;;
    *) die "invalid action '$ACTION' (expected: switch, boot, test, build, dry-activate)" ;;
  esac
  [ -d "$CONFIG_DIR" ] || die "directory $CONFIG_DIR not found"
  cd "$CONFIG_DIR"
  export FLAKE="$CONFIG_DIR"

  # quieter nix: подавляем "Git tree is dirty" (мы уже сами предупредили в [1/5])
  NIX_EXTRA="warn-dirty = false"
  if [ -n "''${NIX_CONFIG:-}" ]; then
    export NIX_CONFIG="$NIX_CONFIG
  $NIX_EXTRA"
  else
    export NIX_CONFIG="$NIX_EXTRA"
  fi

  START_TIME=$(date +%s)

  # ---- helpers ------------------------------------------------------
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
      gen=$(nixos-rebuild list-generations 2>/dev/null \
        | awk '/\*/ && $1 ~ /^[0-9]/ { sub(/\*/, "", $1); print $1; exit }' || true)
      if [[ "$gen" =~ ^[0-9]+$ ]]; then echo "$gen"; return 0; fi
    fi
    return 1
  }
  in_git()      { git rev-parse --is-inside-work-tree &>/dev/null; }
  has_changes() { ! git diff --cached --quiet || ! git diff --quiet; }

  # ---- banner -------------------------------------------------------
  echo >&2
  hr
  printf '  %s%snr%s  %s%s%s\n' "$BOLD" "$CYN" "$RESET" "$BOLD" "$ACTION" "$RESET" >&2
  printf '  %s%s%s\n' "$DIM" "$CONFIG_DIR" "$RESET" >&2
  hr

  # ---- [1/5] preflight ---------------------------------------------
  step 1 "Preflight"
  IS_GIT=false
  if in_git; then
    IS_GIT=true
    if git ls-files --unmerged | grep -q '^'; then
      fail "merge conflicts detected"
      die "unresolved merge conflicts in repository"
    fi
    if [ -n "$(git status --porcelain)" ]; then
      warn "uncommitted changes present (will be staged and committed)"
    else
      ok "git repository clean"
    fi
  else
    warn "not a git repository — auto-commit disabled"
  fi

  # ---- [2/5] format -------------------------------------------------
  step 2 "Format"
  if command -v nix &>/dev/null; then
    t0=$(date +%s%N)
    if timeout 60 nix fmt . >/dev/null 2>&1; then
      dt=$(( ($(date +%s%N) - t0) / 1000000 ))
      ok "formatted in ''${dt}ms"
    else
      warn "formatter failed or timed out (continuing)"
    fi
  else
    warn "nix not found in PATH"
  fi

  # ---- [3/5] stage --------------------------------------------------
  step 3 "Stage"
  if [ "$IS_GIT" = true ]; then
    git add -A
    if has_changes; then
      git status --short | sed 's/^/    /' >&2
    else
      ok "nothing to stage"
    fi
  else
    warn "skipped (not a git repository)"
  fi

  # ---- [4/5] rebuild ------------------------------------------------
  PREV_GEN=$(get_current_gen || true)
  step 4 "Rebuild"
  kv "action" "$ACTION"
  [ -n "''${PREV_GEN:-}" ] && kv "from gen" "$PREV_GEN"
  echo >&2
  hr
  echo >&2
  if ! nh os "$ACTION" "$@"; then
    echo >&2
    hr
    die "nixos rebuild failed — changes left staged"
  fi
  echo >&2
  hr

  # ---- [5/5] post-build ---------------------------------------------
  NEW_GEN=$(get_current_gen || true)
  step 5 "Post-build"

  COMMIT_HASH=""
  NVD_OUT=""

  case "$ACTION" in
    switch|boot)
      if [ -n "''${PREV_GEN:-}" ] && [ -n "''${NEW_GEN:-}" ] && [ "$PREV_GEN" != "$NEW_GEN" ]; then
        kv "generation" "$PREV_GEN -> $NEW_GEN" "$GRN"
      elif [ -n "''${NEW_GEN:-}" ]; then
        kv "generation" "$NEW_GEN" "$GRN"
      fi

      if [ -n "''${PREV_GEN:-}" ] && [ -n "''${NEW_GEN:-}" ] \
         && [ "$PREV_GEN" != "$NEW_GEN" ] \
         && command -v nvd &>/dev/null; then
        NVD_OUT=$(nvd diff \
          "/nix/var/nix/profiles/system-''${PREV_GEN}-link" \
          "/nix/var/nix/profiles/system-''${NEW_GEN}-link" 2>&1 || true)
      fi

      if [ "$IS_GIT" = true ]; then
        git add -A   # добираем flake.lock, если его тронул nh
        if has_changes; then
          if [ -n "''${NEW_GEN:-}" ]; then REBUILD_NO="$NEW_GEN"
          elif [ -n "''${PREV_GEN:-}" ]; then REBUILD_NO=$(( PREV_GEN + 1 ))
          else REBUILD_NO=""; fi

          if [ -n "$REBUILD_NO" ]; then
            COMMIT_MSG="nixos: rebuild #$REBUILD_NO ($ACTION) — $(date '+%Y-%m-%d %H:%M')"
          else
            COMMIT_MSG="nixos: $ACTION ($(date '+%Y-%m-%d %H:%M'))"
          fi

          if [ -n "$NVD_OUT" ]; then
            git commit -q -m "$COMMIT_MSG" -m "$NVD_OUT"
          else
            git commit -q -m "$COMMIT_MSG"
          fi
          COMMIT_HASH=$(git rev-parse --short HEAD)
          kv "committed" "$COMMIT_HASH" "$GRN"
          printf '  %s%-18s%s %s\n' "$DIM" "" "$RESET" "$COMMIT_MSG" >&2
        else
          info "no configuration changes — commit skipped"
        fi
      fi
      ;;
    *)
      info "action '$ACTION' creates no new generation — commit skipped"
      ;;
  esac

  # ---- summary ------------------------------------------------------
  ELAPSED=$(( $(date +%s) - START_TIME ))
  echo >&2
  hr
  SUMMARY=""
  if [ -n "''${PREV_GEN:-}" ] && [ -n "''${NEW_GEN:-}" ] && [ "$PREV_GEN" != "$NEW_GEN" ]; then
    SUMMARY="gen $PREV_GEN -> $NEW_GEN"
  elif [ -n "''${NEW_GEN:-}" ]; then
    SUMMARY="gen $NEW_GEN"
  fi
  [ -n "$COMMIT_HASH" ] && SUMMARY="''${SUMMARY:+$SUMMARY  |  }commit $COMMIT_HASH"
  SUMMARY="''${SUMMARY:+$SUMMARY  |  }$(fmt_time "$ELAPSED")"
  printf '  %s%sdone%s  %s\n' "$BOLD" "$GRN" "$RESET" "$SUMMARY" >&2
  hr
  echo >&2
''
