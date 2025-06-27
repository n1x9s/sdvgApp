#!/bin/bash

# Скрипт для создания иконок приложения из одного изображения
# Использование: ./create_app_icons.sh image.png

if [ "$#" -ne 1 ]; then
    echo "Использование: $0 <путь_к_изображению>"
    exit 1
fi

INPUT_IMAGE="$1"
ICONSET_DIR="sdvg/Assets.xcassets/AppIcon.appiconset"

# Проверяем, существует ли входное изображение
if [ ! -f "$INPUT_IMAGE" ]; then
    echo "Ошибка: Файл $INPUT_IMAGE не найден"
    exit 1
fi

# Создаем иконки разных размеров
echo "Создание иконок приложения..."

# macOS иконки
sips -z 16 16 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_16x16.png"
sips -z 32 32 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_16x16@2x.png"
sips -z 32 32 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_32x32.png"
sips -z 64 64 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_32x32@2x.png"
sips -z 128 128 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_128x128.png"
sips -z 256 256 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_128x128@2x.png"
sips -z 256 256 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_256x256.png"
sips -z 512 512 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_256x256@2x.png"
sips -z 512 512 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_512x512.png"
sips -z 1024 1024 "$INPUT_IMAGE" --out "$ICONSET_DIR/icon_512x512@2x.png"

echo "Иконки созданы успешно!"
