#!/bin/bash
set -e

# Создание пользователя
sudo useradd --no-create-home --shell /bin/false prometheus

# Создание директорий
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus

# Стабильная версия по умолчанию
DEFAULT_VERSION="2.51.2"
VERSION="${1:-$DEFAULT_VERSION}"

# Определение последней версии при запросе 'latest'
if [ "$VERSION" = "latest" ]; then
  LATEST_TAG=$(curl -s https://api.github.com/repos/prometheus/prometheus/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  VERSION=${LATEST_TAG#v}
fi

echo "Установка Prometheus $VERSION"

# Скачивание и установка
FILE_NAME="prometheus-${VERSION}.linux-amd64"
wget "https://github.com/prometheus/prometheus/releases/download/v${VERSION}/${FILE_NAME}.tar.gz" -O "${FILE_NAME}.tar.gz"

tar xvf "${FILE_NAME}.tar.gz"
cd "${FILE_NAME}"

sudo cp prometheus promtool /usr/local/bin/
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool

# Копирование конфигов
sudo cp ../prometheus.yml /etc/prometheus/
sudo cp ../prometheus.service /etc/systemd/system/

# Запуск сервиса
sudo systemctl daemon-reload
sudo systemctl start prometheus
sudo systemctl enable prometheus

# Проверка
echo "Установка завершена."
echo "Доступ: http://$(hostname -I | awk '{print $1}'):9090"
