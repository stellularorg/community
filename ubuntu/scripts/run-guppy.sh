#!/usr/bin/env bash
cd /home/ubuntu/guppy
sudo pkill -e guppy
./target/release/guppy --port 8081 --staic-dir "/home/ubuntu/guppy/static"
