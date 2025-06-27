#!/bin/bash

# Создание архива проекта для отправки разработчику с Mac

echo "📦 Создание архива проекта..."

# Имя архива с датой
ARCHIVE_NAME="sdvg-project-$(date +%Y%m%d-%H%M%S).zip"

# Создаем архив, исключая ненужные файлы
zip -r "$ARCHIVE_NAME" . \
    -x "*.DS_Store" \
    -x "*/.git/*" \
    -x "*/build/*" \
    -x "*/DerivedData/*" \
    -x "*/.vscode/*" \
    -x "*/xcuserdata/*" \
    -x "*.xcuserstate"

if [ $? -eq 0 ]; then
    echo "✅ Архив создан: $ARCHIVE_NAME"
    echo "📊 Размер архива: $(du -sh "$ARCHIVE_NAME" | cut -f1)"
    echo ""
    echo "🎯 Этот архив содержит:"
    echo "   - Исходный код проекта"
    echo "   - Настроенные иконки"
    echo "   - Все необходимые файлы для сборки"
    echo ""
    echo "📨 Отправьте файл $ARCHIVE_NAME разработчику с Mac"
    echo "   Он сможет открыть проект в Xcode и собрать готовое приложение"
else
    echo "❌ Ошибка при создании архива"
    exit 1
fi
