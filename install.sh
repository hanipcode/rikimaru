#!/usr/bin/env bash
chmod +x ./rk_upload_node;
sudo mkdir /etc/rikimaru;

sudo ln -s "$(pwd)"/html /etc/rikimaru/html;
sudo ln -s "$(pwd)"/scripts /etc/rikimaru/scripts;
sudo ln -s "$(pwd)"/config /etc/rikimaru/config;

# main script
sudo ln -s "$(pwd)/rk_upload_node" /usr/local/bin/rk_upload_node;