# nixos/services/rebuild-script.nix
{ pkgs }:

pkgs.writeScriptBin "nr" ''
  #!/usr/bin/env bash
  set -e

  CONFIG_DIR="/home/utyara3/nixos-config"
  ACTION=''${1:-switch}

  echo "🔄 Переходим в $CONFIG_DIR..."
  cd "$CONFIG_DIR"

  # 🔥 Нативно форматируем все Nix файлы через встроенный CLI
  echo "🧹 Форматируем измененные файлы..."
  nix fmt . &>/dev/null || true

  # 🛠️ СТРАХОВКА ДЛЯ FLAKES: Индексируем абсолютно все новые и измененные файлы ДО сборки.
  # Без этого Nix Flakes просто проигнорирует новые файлы и изменения в них.
  git add -A

  if ! git diff --cached --quiet || ! git diff --quiet; then
    echo "📝 Обнаружены изменения в конфигурации:"
    git status --short
  fi

  echo "🚀 Запуск nixos-rebuild $ACTION..."
  sudo nixos-rebuild "$ACTION" --flake .

  if [ "$ACTION" = "switch" ] || [ "$ACTION" = "boot" ]; then
    # Проверяем, есть ли что коммитить (включая уже добавленное в индекс через git add)
    if ! git diff --cached --quiet || ! git diff --quiet; then
      echo "💾 Сборка успешна! Создаем автокоммит..."
      GENERATION=$(nixos-rebuild list-generations 2>/dev/null | grep 'True$' | awk '{print $1}')
      COMMIT_MSG="nixos-rebuild: generation $GENERATION ($(date '+%Y-%m-%d %H:%M'))"
      
      # Файлы уже добавлены в начале, просто комитим их
      git commit -m "$COMMIT_MSG"
      echo "✅ Изменения автоматически сохранены в Git: '$COMMIT_MSG'"
    else
      echo "ℹ️ Изменений для коммита не обнаружено."
    fi
  fi
''
