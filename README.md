# Home SRE Monitoring Project

[![Prometheus Status](https://img.shields.io/badge/prometheus-active-success)]()
[![Node Exporter](https://img.shields.io/badge/node_exporter-1.9.1-blue)]()
[![Grafana](https://img.shields.io/badge/Grafana-F2F4F9?style=for-the-badge&logo=grafana&logoColor=orange&labelColor=F2F4F9)](https://grafana.com)

## Технологический стек
- **ОС:** Ubuntu Server 24.04.2 LTS
- **Сеть:** Netplan, iwd
- **Мониторинг:** Prometheus 3.5.0, Node Exporter 1.9.1


## Установка Prometheus & Grafana с поддержкой версий

Скрипты установки поддерживают несколько режимов работы с версиями:

### 1. Установка стабильной версии (по умолчанию)
```bash
# Prometheus
./install-prometheus.sh

# Node Exporter
./install-node-exporter.sh
```

### 2. Установка последней версии
```bash
# Prometheus
./install-prometheus.sh latest

# Node Exporter
./install-node-exporter.sh latest
```

### 3. Установка конкретной версии
```bash
# Prometheus v3.0.0
./install-prometheus.sh 3.0.0

# Node Exporter v1.5.0
./install-node-exporter.sh 1.5.0
```

### Основные функции
- Сбор системных метрик (CPU, RAM, Disk, Network)
- Мониторинг состояния сервера в реальном времени
- Готовые конфиги для быстрого развертывания

## Grafana Setup & Dashboard Management

### 1. Install Grafana
```bash
./install-grafana.sh
```

### 2. First Access
- URL: `http://your-server-ip:3000`
- Default login/password: `admin/admin` (change)

### 3. Import Dashboards
#### From Grafana.com:
1. By ID (for example 1860 for Node Exporter Full)
2. In Grafana: Create → Import → Enter ID → Load
3. Select Prometheus datasource → Import

### 4. Create Custom Dashboard
1. **Add visualization** → Select data source (prometheus)
2. **Write PromQL** → Set options → Apply
3. **Settings** → Save dashboard

#### (For example, PromQL) Temperature Monitoring
```promql
node_hwmon_temp_celsius{chip="coretemp-*"}  # Intel
node_hwmon_temp_celsius{chip="k10temp*"}    # AMD
```

### 5. Backup Dashboards
1. Export all dashboards
```bash
sudo cp /var/lib/grafana/grafana.db ~/grafana-backup.db
```
2. Exporting dashboards to JSON files
```bash
# Installing library to work with db
sudo apt install -y sqlite3

# Folder for json files
mkdir -p ~/grafana-export

for uid in $(sqlite3 ~/grafana-backup.db "SELECT uid FROM dashboard"); do data=$(sqlite3 ~/grafana-backup.db "SELECT data FROM dashboard WHERE uid = '$uid'"); echo "$data" > ~/grafana-export/"${uid}".json; done
```
