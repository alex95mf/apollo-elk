#!/bin/bash
curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-8.12.0-amd64.deb
sudo dpkg -i metricbeat-8.12.0-amd64.deb

LOCALHOST=$(hostname -f)

sudo cat <<-'YML' > /etc/metricbeat/metricbeat.yml
metricbeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression

setup.kibana:
  host: "192.168.56.17:5601"

output.elasticsearch:
  hosts: ["192.168.56.17:9200"]
  preset: balanced
  protocol: "https"
  username: "elastic"
  password: "elasticunir2024"

processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
YML

if [ $LOCALHOST = 'elastic' ]; then
  sudo sed -i 's/192.168.56.17/localhost/g' /etc/metricbeat/metricbeat.yml
fi

sudo metricbeat modules enable system
sudo metricbeat setup
sudo systemctl enable --now metricbeat