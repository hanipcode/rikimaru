#!/usr/bin/env bash
chmod +x ./rk_upload_node;

sudo ln -s "$(pwd)/trycatch.sh" /usr/local/bin/trycatch.sh || true
sudo ln -s "$(pwd)/rk_upload_node" /usr/local/bin/rk_upload_node || true