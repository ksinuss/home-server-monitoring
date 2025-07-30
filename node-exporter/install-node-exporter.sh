#!/bin/bash
set -e

# Стабильная версия по умолчанию
DEFAULT_VERSION="1.7.0"
VERSION="${1:-$DEFAULT_VERSION}"

# Определение последней версии при запросе 'latest'
if [ "$VERSION" = "latest" ]; then
  echo "Определение последней версии Node Exporter..."
  LATEST_TAG=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  VERSION=${LATEST_TAG#v}
  echo "Найдена последняя версия: $VERSION"
fi

echo "Установка Node Exporter $VERSION"

# Скачивание и установка
FILE_NAME="node_exporter-${VERSION}.linux-amd64"
wget "https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/${FILE_NAME}.tar.gz" -O "${FILE_NAME}.tar.gz"

tar xvf "${FILE_NAME}.tar.gz"
cd "${FILE_NAME}"

sudo cp node_exporter /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/node_exporter

# Копирование сервиса
sudo cp ../node-exporter.service /etc/systemd/system/

# Запуск сервиса
sudo systemctl daemon-reload
sudo systemctl start node_exporter
sudo systemctl enable node_exporter

# Проверка
echo "Установка завершена. Проверить метрики:"
echo "curl http://localhost:9100/metrics"
