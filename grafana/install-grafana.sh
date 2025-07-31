#!/bin/bash
set -e

# Install prerequisites
sudo apt-get update
sudo apt-get install -y apt-transport-https software-properties-common wget curl

# Add Grafana repository
sudo mkdir -p /usr/share/keyrings/
curl -fsSL https://packages.grafana.com/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/grafana.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

# Install Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Configure Grafana
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

# Create provisioning directory structure
sudo mkdir -p /etc/grafana/provisioning/{datasources,dashboards}
sudo chown -R grafana:grafana /etc/grafana/provisioning

# Create default Prometheus datasource
sudo tee /etc/grafana/provisioning/datasources/prometheus.yml >/dev/null <<EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://localhost:9090
    isDefault: true
EOF

# Final setup
sleep 10 

echo "Grafana installation completed successfully!"
echo "Access Grafana at: http://$(hostname -I | awk '{print $1}'):3000"
echo "Default login/password: admin / admin"
