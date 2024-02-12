# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "elastic" do |elastic|
    elastic.vm.box = "bento/ubuntu-22.04"
    elastic.vm.hostname = "elastic"
    elastic.vm.network "private_network", ip: "192.168.56.17"

    elastic.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
    end

    elastic.vm.provision "file", source: "./elk/docker-compose.yml", destination: "/home/vagrant/docker-compose.yml"
    elastic.vm.provision "file", source: "./elk/env.txt", destination: "/home/vagrant/.env"

    elastic.vm.provision "docker"
    elastic.vm.provision "shell", inline: <<-ELK
      sudo sysctl -w vm.max_map_count=262144
      sudo echo vm.max_map_count=262144 >> /etc/sysctl.conf
      docker compose up -d
    ELK

    elastic.vm.provision "shell", path: "scripts/apm.sh"
  end

  config.vm.define "apollo" do |apollo|
    apollo.vm.box = "bento/ubuntu-22.04"
    apollo.vm.hostname = "apollo-server"
    apollo.vm.network "private_network", ip: "192.168.56.18"

    apollo.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
    end

    apollo.vm.provision "shell", path: "scripts/apollo.sh"
    apollo.vm.provision "shell", inline: "sudo mv /vagrant/apollo/elastic-ca.crt /etc/ssl/certs"
    apollo.vm.provision "shell", path: "scripts/metricbeat.sh"
    apollo.vm.provision "shell", path: "scripts/filebeat.sh"
  end
end