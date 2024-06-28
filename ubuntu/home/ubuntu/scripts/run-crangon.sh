#!/usr/bin/env bash
cd /home/ubuntu/crangon
sudo pkill -e crangon
./target/release/crangon --port 8080 --staic-dir "/home/ubuntu/crangon/static"
