# nixos/scripts/copy-file-with-filename.nix

{ pkgs }:

pkgs.writeScriptBin "copy" ''
  #!/usr/bin/env bash
  set -eo pipefail

  # Добавляем wl-clipboard в PATH скрипта
  PATH="${pkgs.wl-clipboard}/bin:$PATH"

  # Проверяем, передан ли файл
  if [ -z "''${1:-}" ]; then
      echo "Ошибка: Укажите файл."
      echo "Использование: copy <файл>"
      exit 1
  fi

  SOURCE_FILE="$1"

  # Проверяем существование файла
  if [ ! -f "$SOURCE_FILE" ]; then
      echo "Ошибка: Файл '$SOURCE_FILE' не найден."
      exit 1
  fi

  # Получаем абсолютный путь и имя файла
  FULL_PATH=$(realpath "$SOURCE_FILE")
  FILE_NAME=$(basename "$SOURCE_FILE")

  # Выводим в терминал полный путь и содержимое
  echo "$FULL_PATH"
  cat "$SOURCE_FILE"

  # Копируем в буфер обмена wl-copy сразу И имя, И содержимое
  (echo -e "$FULL_PATH\n"; cat "$SOURCE_FILE") | wl-copy
''
