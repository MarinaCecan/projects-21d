#!/bin/bash
sleep 15
sudo apt update -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo chmod +x /home/ubuntu/packer-web/deamon-script.sh
cd /home/ubuntu/web
npm install
sudo systemctl daemon-reload
sudo systemctl start exchange-web.service
sudo systemctl enable exchange-web.service
