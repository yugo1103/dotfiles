#!/bin/bash

check_os(){
    os_name="$(uname)"
    if [ "$os_name" != "Linux" ]; then
        print_error "Sorry, this script is intended only for LinuxOS"
        exit 1
    fi
}


set -eu
DOT_DIRECTORY="${HOME}/dotfiles"
DOT_CONFIG_DIRECTORY=".config"

echo "link home directory dotfiles"
cd ${DOT_DIRECTORY}
for f in .??*
do
    #無視したいファイルやディレクトリ
    [ "$f" = ".git" ] && continue
    [ "$f" = ".config" ] && continue
    ln -snfv ${DOT_DIRECTORY}/${f} ${HOME}/${f}
done

#echo "link .config directory dotfiles"
#cd ${DOT_DIRECTORY}/${DOT_CONFIG_DIRECTORY}
#for file in `\find . -maxdepth 8 -type f`; do
#./の2文字を削除するためにfile:2としている
#    ln -snfv ${DOT_DIRECTORY}/${DOT_CONFIG_DIRECTORY}/${file:2} ${HOME}/${DOT_CONFIG_DIRECTORY}/${file:2}
#done

echo "linked dotfiles complete!"



packagelist=(
    "apt-utils"
    "software-properties-common"
    "sudo"
    "git"
    "language-pack-ja-base"
    "tmux"
    "gawk"
    "zsh"
)

echo "start apt-get install apps..."
for list in ${packagelist[@]}; do
    sudo -E apt-get install -y ${list}
done

sudo -E apt-get update
sudo -E apt-get upgrade

#vimインストール
sudo -E add-apt-repository ppa:jonathonf/vim
sudo -E apt-get update
sudo -E apt-get install vim

#zplugインストール
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh

#fzfインストール
git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.fzf
${HOME}/.fzf/install

