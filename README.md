dotfiles for tmux and neovim
===

# get started

## install neovim
```
sudo apt-get install software-properties-common

sudo apt-get install python-software-properties

sudo apt-add-repository ppa:neovim-ppa/stable
sudo apt-get update
sudo apt-get install neovim
```

## install pip (if needed)
```
git clone https://github.com/pyenv/pyenv ~/.pyenv
pyenv install 3.5.1

echo '#pyenv' > ~/.zshrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' > ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' > ~/.zshrc
echo 'eval "$(pyenv init - --no-rehash)"' > ~/.zshrc

pyenv global 3.5.1
pip install neovim jedi
```
## install ctags (if needed)
```
sudo apt install ctags
```
or install from src
```
wget http://prdownloads.sourceforge.net/ctags/ctags-5.8.tar.gz
tar zxf ctags-5.8.tar.gz
cd ctags-5.8
./configure --prefix=$HOME/local
make
sudo make install
```

## download configs
remove old neovim config files if it's existed.
```
mv ~/.config/nvim ~/.config/nvim.old
```
install
```
git clone [this url]
cd ~/dotfiles
./dotlink.sh
```

# requirements
neovim  
tmux 2.7  
zsh
```
pip install neovim #(for neovim)
pip install jedi #(for neovim)
```
ctags

# uninstall
```
cd ~/dotfiles
./dotunlink.sh
```
