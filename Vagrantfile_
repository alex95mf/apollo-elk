Vagrant.configure("2") do |config|
  # Configuración de la máquina virtual
  config.vm.box = "bento/ubuntu-22.04"
  config.vm.network "private_network", ip: "192.168.56.18"

  # Configuración del proveedor de la máquina virtual (VirtualBox)
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end

  # Aprovisionamiento mediante shell script
  config.vm.provision "shell", inline: <<-SHELL
    # Instalación de dependencias y herramientas necesarias
    sudo apt-get install -y ca-certificates curl gnupg # Instala certificados, curl y gnupg
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg # Descarga y añade la clave GPG de NodeSource al sistema
    echo "deb https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list # Agrega el repositorio de NodeSource para Node.js 20.x al archivo de fuentes de paquetes
    sudo apt-get update # Actualiza la lista de paquetes disponibles

    # Instalación de Node.js, Nginx, npm, pm2 y otras dependencias globales
    sudo apt-get install -y nodejs nginx # Instala Node.js y Nginx
    sudo npm install -g npm@latest pm2@latest # Instala las últimas versiones de npm y pm2 globalmente

    # Copia del proyecto Apollo al directorio del usuario vagrant
    cp -r /vagrant/apollo /home/vagrant # Copia el directorio 'apollo' desde la carpeta compartida a /home/vagrant
    cd /home/vagrant/apollo # Cambia al directorio 'apollo'

    # Instalación de dependencias del proyecto Apollo
    npm install @apollo/server graphql # Instala las dependencias de Apollo Server y GraphQL

    # Inicia el servidor Apollo usando pm2
    pm2 start index.js # Inicia el servidor Apollo
    pm2 startup systemd # Configura pm2 para iniciar con el sistema utilizando systemd
    sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant # Configura pm2 para el usuario vagrant
    pm2 save # Guarda el estado actual de los procesos gestionados por pm2

    # Configuración de Nginx para servir la aplicación Apollo
    sudo cp /vagrant/apollo/nginx.conf /etc/nginx/nginx.conf # Copia la configuración de Nginx desde el directorio compartido
    sudo cp /vagrant/apollo/apollo.conf /etc/nginx/conf.d/apollo.conf # Copia la configuración específica de la aplicación Apollo
    sudo systemctl enable nginx # Habilita Nginx para que se inicie automáticamente al arrancar el sistema
    sudo systemctl restart nginx # Reinicia Nginx para aplicar los cambios de configuración
  SHELL
end
