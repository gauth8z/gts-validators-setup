# TELECHARGEMENT
wget https://github.com/prometheus/prometheus/releases/download/v2.33.3/prometheus-2.33.3.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
wget https://github.com/ncabatoff/process-exporter/releases/download/v0.7.10/process-exporter-0.7.10.linux-amd64.tar.gz
wget https://github.com/prometheus/alertmanager/releases/download/v0.23.0/alertmanager-0.23.0.linux-amd64.tar.gz

# Decompression
tar xvf prometheus-*
tar xvf node_exporter-*
tar xvf process-exporter-*
tar xvf alertmanager-*.tar.gz

# Cp dans /usr/local/bin/
sudo cp ./prometheus-*.linux-amd64/prometheus /usr/local/bin/
sudo cp ./prometheus-*.linux-amd64/promtool /usr/local/bin/
sudo cp -r ./prometheus-*.linux-amd64/consoles /etc/prometheus
sudo cp -r ./prometheus-*.linux-amd64/console_libraries /etc/prometheus
sudo cp ./node_exporter-*.linux-amd64/node_exporter /usr/local/bin/
sudo cp ./process-exporter-*.linux-amd64/process-exporter /usr/local/bin/
sudo cp ./alertmanager-*.linux-amd64/alertmanager /usr/local/bin/
sudo cp ./alertmanager-*.linux-amd64/amtool /usr/local/bin/

# Creation utilisateurs dediés
sudo useradd --no-create-home --shell /usr/sbin/nologin prometheus
sudo useradd --no-create-home --shell /usr/sbin/nologin node_exporter
sudo useradd --no-create-home --shell /usr/sbin/nologin process-exporter
sudo useradd --no-create-home --shell /usr/sbin/nologin alertmanager

# Creation des repertoires
sudo mkdir /var/lib/prometheus
sudo mkdir /etc/process-exporter
sudo mkdir /etc/alertmanager
sudo mkdir /var/lib/alertmanager

# Change appartenance

sudo chown prometheus:prometheus /etc/prometheus/ -R
sudo chown prometheus:prometheus /var/lib/prometheus/ -R
sudo chown prometheus:prometheus /usr/local/bin/prometheus
sudo chown prometheus:prometheus /usr/local/bin/promtool
sudo chown node_exporter:node_exporter /usr/local/bin/node_exporter
sudo chown process-exporter:process-exporter /etc/process-exporter -R
sudo chown process-exporter:process-exporter /usr/local/bin/process-exporter
sudo chown alertmanager:alertmanager /etc/alertmanager/ -R
sudo chown alertmanager:alertmanager /var/lib/alertmanager/ -R
sudo chown alertmanager:alertmanager /usr/local/bin/alertmanager
sudo chown alertmanager:alertmanager /usr/local/bin/amtool

# Clean up
rm -rf ./prometheus*
rm -rf ./node_exporter*
rm -rf ./process-exporter*
rm -rf ./alertmanager*

# Configuration
sudo cp config/prometheus.yml /etc/prometheus/prometheus.yml
sudo cp config/rules.yml /etc/prometheus/rules.yml
sudo cp config/config.yml /etc/process-exporter/config.yml
sudo cp config/alertmanager.yml /etc/alertmanager/alertmanager.yml

# Systemd
sudo cp service/prometheus.service /etc/systemd/system/prometheus.service
sudo cp service/node_exporter.service /etc/systemd/system/node_exporter.service
sudo cp service/process-exporter.service /etc/systemd/system/process-exporter.service
sudo cp service/alertmanager.service /etc/systemd/system/alertmanager.service

# daemon reload + start services
sudo systemctl start prometheus.service
sudo systemctl start node_exporter.service
sudo systemctl start process-exporter.service
sudo systemctl start alertmanager.service

# Verifications

# enable
sudo systemctl enable prometheus.service
sudo systemctl enable node_exporter.service
sudo systemctl enable process-exporter.service
sudo systemctl enable alertmanager.service

# Test alert-manager
#curl -H "Content-Type: application/json" -d '[{"Test":{"Alert mail par Gmail":"Good !"}}]' localhost:9093/api/v1/alerts

# Plugins Grafana
sudo grafana-cli plugins install camptocamp-prometheus-alertmanager-datasource

## Add Grafana + install
sudo apt-get install -y apt-transport-https
sudo apt-get install -y software-properties-common wget
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update
sudo apt-get install grafana
