# nixos/scripts/copy-file-with-filename.nix

{ pkgs }:

pkgs.writeScriptBin "copy" ''
  #!/usr/bin/env bash
  set -eo pipefail

  # Добавляем wl-clipboard в PATH скрипта, чтобы команда wl-copy всегда была доступна
  PATH="${pkgs.wl-clipboard}/bin:$PATH"

  # Проверяем, передан ли файл
  if [ -z "''${1:-}" ]; then
      echo "Ошибка: Укажите файл для копирования."
      echo "Использование: copy <путь_к_файлу>"
      exit 1
  fi

  SOURCE_FILE="$1"

  # Проверяем, существует ли исходный файл
  if [ ! -f "$SOURCE_FILE" ]; then
      echo "Ошибка: Файл '$SOURCE_FILE' не найден."
      exit 1
  fi

  # Целевая папка и итоговый путь
  TARGET_DIR="/home/utyara3"
  FILE_NAME=$(basename "$SOURCE_FILE")
  TARGET_PATH="$TARGET_DIR/$FILE_NAME"

  # Создаем целевую папку, если её вдруг нет
  mkdir -p "$TARGET_DIR"

  # Копируем файл в целевую директорию
  cp "$SOURCE_FILE" "$TARGET_PATH"

  # Копируем содержимое файла в буфер обмена Wayland
  wl-copy < "$TARGET_PATH"

  # Выводим информацию в терминал (путь и содержимое)
  echo "$TARGET_PATH"
  cat "$TARGET_PATH"
''
