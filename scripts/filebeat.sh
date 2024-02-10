#!/bin/bash

# Mensaje de inicio
echo "Iniciando la instalacion de Filebeat..."

# Paso 1: Descargar e instalar Filebeat
echo "Descargando e instalando Filebeat..."
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.12.0-amd64.deb
sudo dpkg -i filebeat-8.12.0-amd64.deb

# Mensaje de confirmacion
echo "Filebeat instalado correctamente."

# Paso 2: Crear y escribir en el archivo filebeat.yml
echo "Creando y escribiendo en el archivo filebeat.yml..."
sudo tee /etc/filebeat/filebeat.yml > /dev/null <<EOF
filebeat.inputs:
  - type: filestream
    id: my-filestream-id
    enabled: false
    paths:
      - /var/log/*.log

filebeat.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false

setup.template.settings:
  index.number_of_shards: 1

setup.kibana:
  host: "http://192.168.56.17:5601"

output.elasticsearch:
  hosts: ["192.168.56.17:9200"]
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
echo "Archivo filebeat.yml creado y escrito correctamente."

# Paso 3: Crear y escribir en el archivo nginx.yml
echo "Creando y escribiendo en el archivo nginx.yml..."
sudo tee /etc/filebeat/modules.d/nginx.yml > /dev/null <<EOF
- module: nginx
  access:
    enabled: true
    var.paths: ["/var/log/nginx/access.log*"]
  error:
    enabled: true
    var.paths: ["/var/log/nginx/error.log*"]
  ingress_controller:
    enabled: false
EOF

# Mensaje de confirmacion
echo "Archivo nginx.yml creado y escrito correctamente."

# Paso 4: Habilitar el modulo NGINX
echo "Habilitando y configurando el modulo NGINX..."
sudo filebeat modules enable nginx

# Mensaje de confirmacion
echo "Modulo NGINX habilitado y configurado correctamente."

# Paso 5: Iniciar Filebeat
echo "Iniciando Filebeat..."
echo "Ejecutando comando: filebeat setup"
sudo filebeat setup

echo "Ejecutando comando: service filebeat start"
sudo service filebeat start

# Mensaje de confirmacion
echo "Filebeat iniciado correctamente."

# Paso 6: Verificar que se esten recibiendo datos del modulo NGINX
echo "Verificando la recepcion de datos del modulo NGINX..."
sudo filebeat test output

# Mensaje de confirmacion final
echo "Instalacion completada exitosamente."
