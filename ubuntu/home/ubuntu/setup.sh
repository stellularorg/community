# this will just handle installing crangon/guppy and then starting them
# networking is manual

# deps
sudo apt update
sudo apt-get install build-essential pkg-config unzip libssl-dev -y
sudo apt install nodejs npm -y

cd $HOME
curl -fsSL https://bun.sh/install | bash
echo "export BUN_INSTALL=\"$HOME/.bun\"\nexport PATH=\"$BUN_INSTALL/bin:\$PATH\"" >> .bashrc
source ~/.bashrc

export BUN="$HOME/.bun/bin/bun"

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

export CARGO="$HOME/.cargo/bin/cargo"
$CARGO install just sproc
export SPROC="$HOME/.cargo/bin/sproc"
export JUST="$HOME/.cargo/bin/just"

# redis
sudo apt install redis-server
sudo systemctl enable --now redis-server

# guppy
cd $HOME
git clone https://github.com/stellularorg/guppy
cd guppy

touch main.db
$BUN i
$JUST build sqlite

# .env
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/guppy/.env
echo "Edit the Crangon config with \"vim /home/ubuntu/guppy/.env\""

# crangon
cd $HOME
git clone https://github.com/stellularorg/crangon
cd crangon

# ...
ln -s $HOME/guppy/main.db main.db
$BUN i
$JUST build sqlite

# .env
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/crangon/.env
echo "Edit the Crangon config with \"vim /home/ubuntu/crangon/.env\""

# scripts
cd $HOME
mkdir scripts
cd scripts

wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/scripts/run-crangon.sh
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/scripts/run-guppy.sh
chmod +x run-crangon.sh
chmod +x run-guppy.sh

# sproc
mkdir $HOME/.config/sproc
cd $HOME/.config/sproc
wget https://raw.githubusercontent.com/stellularorg/community/master/ubuntu/home/ubuntu/.config/sproc/services_custom.toml

$SPROC pin services_custom.toml
$SPROC run-all

# remove self
cd $HOME
rm setup.sh
