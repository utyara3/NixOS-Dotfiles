# nixos/services/rebuild-script.nix
{ pkgs }:

pkgs.writeScriptBin "nr" ''
  #!/usr/bin/env bash
  # Структруно падаем при любых ошибках, включая пайпы (pipefail)
  set -eo pipefail

  CONFIG_DIR="/home/utyara3/nixos-config"
  ACTION=''${1:-switch}

  echo "🔄 Переходим в $CONFIG_DIR..."
  cd "$CONFIG_DIR"

  echo "🧹 Форматируем измененные файлы..."
  nix fmt . &>/dev/null || true

  git add -A &>/dev/null

  if ! git diff --cached --quiet || ! git diff --quiet; then
    echo "📝 Обнаружены изменения в конфигурации:"
    git status --short
  fi

  echo "🚀 Запуск nh os $ACTION..."

  # Включаем локальный pipefail только для этой строки, чтобы grep не скрывал ошибку nh
  if ! (set -o pipefail; nh os "$ACTION" "$CONFIG_DIR" 2>&1 | grep -v -E '^[^> ]+>'); then
    echo "❌ Ошибка: Сборка NixOS завершилась неудачно! Коммит отменен."
    exit 1
  fi

  # Сюда скрипт дойдет ТОЛЬКО если nh os завершился с кодом 0
  if [ "$ACTION" = "switch" ] || [ "$ACTION" = "boot" ]; then
    if ! git diff --cached --quiet || ! git diff --quiet; then
      echo "💾 Сборка успешна! Создаем автокоммит..."
      GENERATION=$(nixos-rebuild list-generations 2>/dev/null | grep 'True$' | awk '{print $1}')
      COMMIT_MSG="nixos-rebuild: generation $GENERATION ($(date '+%Y-%m-%d %H:%M'))"
      
      git commit -m "$COMMIT_MSG"
      echo "✅ Изменения автоматически сохранены в Git: '$COMMIT_MSG'"
    else
      echo "ℹ️ Изменений для коммита не обнаружено."
    fi
  fi
''
