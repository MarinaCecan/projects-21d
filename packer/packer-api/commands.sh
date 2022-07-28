#!/bin/bash
sleep 15
sudo apt update -y
sudo apt install nodejs -y
sudo apt install npm -y
sudo chmod +x /home/ubuntu/packer-api/deamon-script.sh
cd /home/ubuntu/api
npm install
sudo systemctl daemon-reload
sudo systemctl start exchange-api.service
sudo systemctl enable exchange-api.service
