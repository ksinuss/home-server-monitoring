# Home SRE Monitoring Project

## Технологический стек
- **ОС:** Ubuntu Server 24.04.2 LTS
- **Сеть:** Netplan, iwd

## Установка с поддержкой версий

Скрипты установки поддерживают несколько режимов работы с версиями:

### 1. Установка стабильной версии (по умолчанию)
```bash
# Prometheus
cd prometheus
./install-prometheus.sh

# Node Exporter
cd ../node-exporter
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
