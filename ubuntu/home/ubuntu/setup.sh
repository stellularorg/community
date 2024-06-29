# this will just handle installing crangon/guppy and then starting them
# networking is manual

# deps
sudo apt install build-essential pkg-config unzip libssl-dev nodejs npm

cd $HOME
curl -fsSL https://bun.sh/install | bash
echo "export BUN_INSTALL=\"$HOME/.bun\"\nexport PATH=\"$BUN_INSTALL/bin:\$PATH\"" >> .bashrc
source ~/.bashrc

# use bunx if we have it, alias npx as bunx if we don't
if [ ! -f $HOME/.bun/bin/bunx ]; then
    # ln -s $HOME/.bun/bin/bun $HOME/.bun/bin/bunx
    ln -s /usr/bin/npx $HOME/.bun/bin/bunx
    echo "bunx alias created (npx)"
else
    echo "bunx is fine"
fi

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
. "$HOME/.cargo/env"

cargo install just

# redis
sudo snap install redis
sudo systemctl enable --now redis-server

# guppy
cd $HOME
git clone https://github.com/stellularorg/guppy
cd guppy

touch main.db
bun i
just build sqlite

# .env
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/guppy/.env
echo "Edit the Crangon config with \"vim /home/ubuntu/guppy/.env\""

# crangon
cd $HOME
git clone https://github.com/stellularorg/crangon
cd crangon

# apply patch until crangon is fixed
git checkout c92cedc0c29912d823a4bb8e1cc049a11924d5d6
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/patches/dorsal.patch
git am < dorsal.patch
rm dorsal.patch

# ...
ln -s $HOME/guppy/main.db main.db
bun i
just build sqlite

# .env
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/crangon/.env
echo "Edit the Crangon config with \"vim /home/ubuntu/crangon/.env\""

# scripts
cd $HOME
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
cd $HOME
rm setup.sh
