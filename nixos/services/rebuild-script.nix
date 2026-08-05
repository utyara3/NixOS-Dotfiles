# nixos/services/rebuild-script.nix
{ pkgs }:

pkgs.writeScriptBin "nr" ''
  #!/usr/bin/env bash
  set -e

  CONFIG_DIR="/home/utyara3/nixos-config"
  ACTION=''${1:-switch}

  echo "🔄 Переходим в $CONFIG_DIR..."
  cd "$CONFIG_DIR"

  echo "🧹 Форматируем измененные файлы..."
  nix fmt . &>/dev/null || true

  # Индексируем изменения для флейка до сборки
  git add -A

  if ! git diff --cached --quiet || ! git diff --quiet; then
    echo "📝 Обнаружены изменения в конфигурации:"
    git status --short
  fi

  # 🔥 ЗАМЕНЯЕМ НА NH OS: Запуск сборки через красивый хелпер
  # nh сам запросит пароль sudo, когда это потребуется для активации системы
  echo "🚀 Запуск nh os $ACTION..."
  nh os "$ACTION"

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
