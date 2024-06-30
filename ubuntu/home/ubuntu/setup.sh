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

cargo install just sproc

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

# sproc
cd $HOME/.config/sproc
sproc pin services_custom.toml
sproc run-all

# remove self
cd $HOME
rm setup.sh
