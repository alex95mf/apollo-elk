#!/bin/bash
sudo apt-get install -y ca-certificates curl gnupg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/nodesource.gpg
echo "deb https://deb.nodesource.com/node_20.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt-get update
sudo apt-get install nodejs -y
sudo npm install -g npm@latest pm2@latest
#
cp -r /vagrant/apollo /home/vagrant
cd /home/vagrant/apollo
npm install @apollo/server graphql
npm install elastic-apm-node --save
#npm start

pm2 start index.js
pm2 startup systemd
sudo env PATH=$PATH:/usr/bin /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u vagrant --hp /home/vagrant
pm2 save

sudo apt install -y nginx
sudo cp /vagrant/apollo/nginx.conf /etc/nginx/nginx.conf
sudo cp /vagrant/apollo/apollo.conf /etc/nginx/conf.d/apollo.conf
sudo systemctl enable nginx
sudo systemctl restart nginx
