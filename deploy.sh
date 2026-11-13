#!/bin/bash
set -e # Завершать при возникновении ошибки

# ================= 配置区 =================
PROJECT_DIR="/opt/my-resume-site"   # Абсолютный путь к проекту на сервере
BRANCH="main"                       # Ветка для развертывания
CONTAINER_NAME="resume-app"         # Имя контейнера
IMAGE_NAME="my-resume-site:latest"  # Имя образа
HOST_PORT="80"                      # Внешний порт
# ==========================================

echo ">>> Переход в каталог проекта..."
cd "$PROJECT_DIR"

echo ">>> Извлечение последних изменений ветки $BRANCH..."
git fetch origin
git checkout "$BRANCH"
git pull origin "$BRANCH"

echo ">>> Сборка образа Docker..."
docker build -t "$IMAGE_NAME" .

echo ">>> Остановка и удаление старого контейнера (если существует)..."
if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    docker stop "$CONTAINER_NAME" || true
    docker rm "$CONTAINER_NAME" || true
fi

echo ">>> Запуск нового контейнера..."
docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p "$HOST_PORT:80" \
    "$IMAGE_NAME"

echo ">>> Проверка статуса контейнера..."
sleep 2
docker ps -f name="$CONTAINER_NAME"

echo "✅ Развертывание завершено! Посетите http://<IP-сервера>"