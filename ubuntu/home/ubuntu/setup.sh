# this will just handle installing crangon/guppy and then starting them
# networking is manual

# deps
sudo apt install build-essential pkg-config unzip

curl -fsSL https://bun.sh/install | bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install just

# redis
sudo snap install redis
sudo systemctl enable --now redis-server

# guppy
cd /home/ubuntu
git clone https://github.com/stellularorg/guppy
cd guppy

touch main.db
bun i
just build sqlite

# crangon
cd /home/ubuntu
git clone https://github.com/stellularorg/crangon
cd crangon

ln -s /home/ubuntu/guppy/main.db main.db
bun i
just build sqlite

# scripts
cd /home/ubuntu
mkdir scripts
cd scripts

wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/scripts/run-crangon.sh
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/scripts/run-guppy.sh
chmod +x run-crangon.sh
chmod +x run-guppy.sh

# services
cd /etc/systemd/system
sudo wget https://github.com/stellularorg/community/raw/master/ubuntu/etc/systemd/system/crangon.service
sudo wget https://github.com/stellularorg/community/raw/master/ubuntu/etc/systemd/system/guppy.service

# remove self
cd /home/ubuntu
rm setup.sh
