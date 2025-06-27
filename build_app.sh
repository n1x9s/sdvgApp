#!/bin/bash

# Скрипт для сборки и создания готового приложения
# Требует полную версию Xcode

echo "🔨 Сборка приложения sdvg..."

# Создаем папку для сборки
BUILD_DIR="build"
mkdir -p "$BUILD_DIR"

# Собираем приложение
xcodebuild -project sdvg.xcodeproj \
          -scheme sdvg \
          -configuration Release \
          -derivedDataPath "$BUILD_DIR/DerivedData" \
          build

if [ $? -eq 0 ]; then
    echo "✅ Сборка успешна!"
    
    # Находим созданное приложение
    APP_PATH=$(find "$BUILD_DIR" -name "*.app" -type d | head -1)
    
    if [ -n "$APP_PATH" ]; then
        echo "📦 Приложение найдено: $APP_PATH"
        
        # Копируем приложение в корень проекта
        cp -R "$APP_PATH" "./sdvg.app"
        
        echo "🎉 Готово! Приложение sdvg.app создано в корне проекта"
        echo "Вы можете поделиться файлом sdvg.app с другими пользователями Mac"
        
        # Показываем размер приложения
        echo "📊 Размер приложения: $(du -sh sdvg.app | cut -f1)"
        
    else
        echo "❌ Не удалось найти собранное приложение"
        exit 1
    fi
else
    echo "❌ Ошибка при сборке приложения"
    exit 1
fi
