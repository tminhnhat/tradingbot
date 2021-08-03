#/bin/bash

CURRENTPATH=`pwd`

echo "Frostybot install started" 

echo "Updating package manager..."
export DEBIAN_FRONTEND=noninteractive
export DEBIAN_PRIORITY=critical
sudo -E apt-get -qy update >> /tmp/install.log 2>&1

echo "Installing prerequisite packages for Frostybot..."
sudo -E apt-get -qy -o "Dpkg::Options::=--force-confdef" -o "Dpkg::Options::=--force-confold" install nodejs npm jq wget git sqlite3 >> /tmp/install.log 2>&1

echo "Cloning Frostybot Github repository..."
sudo mkdir -p /usr/local && cd /usr/local/
sudo git clone https://github.com/tminhnhat/tradingbot.git frostybot-js >> /tmp/install.log 2>&1

echo "Setting permissions..."
cd /usr/local/frostybot-js
sudo chgrp $USER -R /usr/local/frostybot-js >> /tmp/install.log 2>&1
sudo npm install --unsafe-perm >> /tmp/install.log 2>&1

echo "Creating frostybot command shortcut..." 
sudo rm -Rf /usr/bin/frostybot
sudo ln -s /usr/local/frostybot-js/frostybot /usr/bin/frostybot >> /tmp/install.log 2>&1

frostybot start
frostybot autostart

cd "$CURRENTPATH" &
frostybot gui:enable email=nhatco@gmail.com password=tiendien
echo "Frostybot install completed!"
echo ""
echo "You can start the server using this command:   frostybot start"
echo "You can stop the server using this command:    frostybot stop"
echo "You can upgrade the server using this command: frostybot upgrade"
echo ""
echo "bat dau cai docker"
cd ~
mkdir nodered
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io


echo "bat dau cai potiner"
docker volume create portainer_data
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "bat dau cai nodered"
docker run -it -p 80:1880 -v /home/ubuntu/nodered:/data --name mynodered nodered/node-red:latest
