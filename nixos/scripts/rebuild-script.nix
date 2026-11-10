# nixos/scripts/rebuild-script.nix
{ pkgs }:

pkgs.writeScriptBin "nr" ''
  #!/usr/bin/env bash
  set -eo pipefail

  CONFIG_DIR="/home/utyara3/nixos-config"
  ACTION=''${1:-switch}

  # Validate input action
  case "$ACTION" in
    switch|boot|test|build|dry-activate) ;;
    *)
      echo "Error: Invalid action '$ACTION'." >&2
      echo "Available options: switch, boot, test, build, dry-activate" >&2
      exit 1
      ;;
  esac

  # Verify configuration directory existence
  if [ ! -d "$CONFIG_DIR" ]; then
    echo "Error: Directory $CONFIG_DIR not found." >&2
    exit 1
  fi

  export FLAKE="$CONFIG_DIR"

  echo "=================================================="
  echo "Switching to directory: $CONFIG_DIR"
  echo "=================================================="
  cd "$CONFIG_DIR"

  # Validate Git repository health before starting build
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    if git ls-files --unmerged | grep -q '^'; then
      echo "Error: Unresolved merge conflicts detected in the repository." >&2
      exit 1
    fi
  else
    echo "Warning: Not a Git repository. Auto-commit disabled."
  fi

  echo "Running formatter..."
  nix fmt . &>/dev/null || true

  # Stage updates to ensure Flake detects new untracked files
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    git add . &>/dev/null
    if ! git diff --cached --quiet || ! git diff --quiet; then
      echo "--------------------------------------------------"
      echo "Staged configuration changes:"
      git status --short
      echo "--------------------------------------------------"
    fi
  fi

  # Cache previous generation ID for package diffing
  PREV_GEN=$(nh os list 2>/dev/null | tail -n 1 | awk '{print $1}' | tr -d '[:space:]' || true)

  echo "Executing: nh os $ACTION"
  echo "=================================================="
  if ! nh os "$ACTION" --; then
    echo "=================================================="
    echo "Error: NixOS rebuild failed. Changes aborted." >&2
    exit 1
  fi
  echo "=================================================="

  # Post-build routines for active deployment actions
  if [ "$ACTION" = "switch" ] || [ "$ACTION" = "boot" ]; then
    # Fetch newly generated profile ID
    NEW_GEN=$(nh os list 2>/dev/null | tail -n 1 | awk '{print $1}' | tr -d '[:space:]' || true)

    # Output clean package diff using nvd if available
    if [ -n "$PREV_GEN" ] && [ -n "$NEW_GEN" ] && [ "$PREV_GEN" != "$NEW_GEN" ] && command -v nvd &>/dev/null; then
      echo "Analyzing package changes..."
      echo "--------------------------------------------------"
      nvd diff "/nix/var/nix/profiles/system-''${PREV_GEN}-link" "/nix/var/nix/profiles/system-''${NEW_GEN}-link" || true
      echo "--------------------------------------------------"
    fi

    # Handle automatic Git commit
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      if ! git diff --cached --quiet || ! git diff --quiet; then
        echo "Build successful. Creating auto-commit..."
        
        if [ -z "$NEW_GEN" ]; then
          COMMIT_MSG="nixos: update ($(date '+%Y-%m-%d %H:%M'))"
        else
          COMMIT_MSG="nixos: generation $NEW_GEN ($(date '+%Y-%m-%d %H:%M'))"
        fi
        
        git commit -m "$COMMIT_MSG"
        echo "Success: Changes saved to Git as '$COMMIT_MSG'"
      else
        echo "No configuration changes detected. Skipping commit."
      fi
    fi
  fi
''
