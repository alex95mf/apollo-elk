#!/bin/bash

# Mensaje de inicio
echo "Iniciando la instalacion de APM..."

# Paso 1: Descargar e instalar APM
echo "Descargando e instalando apm-server..."
curl -L -O https://artifacts.elastic.co/downloads/apm-server/apm-server-8.12.0-amd64.deb
sudo dpkg -i apm-server-8.12.0-amd64.deb

# Mensaje de confirmacion
echo "apm-server instalado correctamente."

# Paso 2: Crear y escribir en el archivo apm-server.yml
echo "Creando y escribiendo en el archivo apm-server.yml..."
sudo tee /etc/apm-server/apm-server.yml > /dev/null <<EOF
apm-server.inputs:
  - type: filestream
    id: my-filestream-id
    enabled: false
    paths:
      - /var/log/*.log

apm-server.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 1

setup.kibana:
  host: "http://localhost:5601"

output.elasticsearch:
  hosts: ["localhost:9200"]
  preset: balanced
  protocol: "https"
  username: "elastic"
  password: "elasticunir2024"

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
EOF

# Mensaje de confirmacion
echo "Archivo apm-server.yml creado y escrito correctamente."

# Paso 3: Iniciar apm-server
echo "Iniciando apm-server..."

echo "Ejecutando comando: service apm-server start"
sudo service apm-server start

# Mensaje de confirmacion
echo "apm-server iniciado correctamente."

# Mensaje de confirmacion final
echo "Instalacion completada exitosamente."
