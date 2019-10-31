#!/bin/bash

set -eu

export MYDOTFILES=$HOME/dotfiles

#directories
FZFDIR="$HOME/.fzf"
ZPLUGDIR="$HOME/.zplug"

# symlinks
ZSHRC="$HOME/.zshrc"

ZSHFILES=(
"$HOME/.zshrc"
"$HOME/.zlogin" 
"$HOME/.zlogout"
"$HOME/.zpreztorc"
"$HOME/.zprofile"
"$HOME/.zshenv"
)

VIMRC="$HOME/.vimrc"
GVIMRC="$HOME/.gvimrc"
TMUXCONF="$HOME/.tmux.conf"
FLAKE8="$HOME/.config/flake8"
VINTRC="$HOME/.vintrc.yml"
EMACSINIT="$HOME/.spacemacs"
TIGRC="$HOME/.tigrc"
if [[ $OSTYPE == 'msys' ]]; then
    NVIMRC="$USERPROFILE/AppData/Local/nvim/init.vim"
    GNVIMRC="$USERPROFILE/AppData/Local/nvim/ginit.vim"
else
    NVIMRC="$HOME/.config/nvim/init.vim"
    GNVIMRC="$HOME/.config/nvim/ginit.vim"
fi

SYMLINKS=(
${VIMRC}
${GVIMRC}
${TMUXCONF}
${FLAKE8}
${VINTRC}
${EMACSINIT}
${NVIMRC}
${GNVIMRC}
${TIGRC}
)

SYMTARGET=(
"${MYDOTFILES}/vim/vimrc.vim"
"${MYDOTFILES}/vim/gvimrc.vim"
"${MYDOTFILES}/tmux/tmux.conf"
"${MYDOTFILES}/python/lint/flake8"
"${MYDOTFILES}/python/lint/vintrc.yml"
"${MYDOTFILES}/emacs/spacemacs"
"${MYDOTFILES}/vim/vimrc.vim"
"${MYDOTFILES}/vim/ginit.vim"
"${MYDOTFILES}/tig/tigrc"
)

#actual files
TMUXLOCAL="$HOME/localrcs/tmux-local"
TRASH="$HOME/.trash"

##############################################
#               MAIN COMMANDS                #
##############################################

backup() {
    echo_section "Making back up files"
    for item in ${ZSHFILES[@]}; do
        if [[ -e $item ]]; then
            backup_file $item
        fi
    done

    for item in ${SYMLINKS[@]}; do
        if [[ -e $item ]]; then
            backup_file $item
        fi
    done
}

ascii_art() {
    cat << EOF 
[34m     _     _   ___ _ _
   _| |___| |_|  _|_| |___ ___
  | . | . |  _|  _| | | -_|_ -|
  |___|___|_| |_| |_|_|___|___|
[7m                    by yugo1103[0m
EOF
sleep 1
}

echo_section() {
    local desc=$1
    local num_desc=${#desc}
    local num_remain=$(tput cols)
    local result=''

    for i in $(seq 5); do
        result="${result}="
        num_remain=$((${num_remain}-1))
    done
    result="${result} "
    num_remain=$((${num_remain}-1))

    result="${result}${desc}"
    num_remain=$((${num_remain}-${num_desc}))

    result="${result} "
    num_remain=$((${num_remain}-1))

    for i in $(seq ${num_remain}); do
        result="${result}="
    done
    echo -e "\n[32m${result}\n[0m"
}

check_arguments() {
    case $1 in
        --help)
            help
            exit 0
            ;;
        install)   ;;
        reinstall) ;;
        redeploy)  ;;
        update)    ;;
        undeploy)  ;;
        uninstall) ;;
        debug)     ;;
        buildtools)     ;;
        *)
            echo "Unknown argument: ${arg}"
            help
            exit 1
            ;;
    esac
}

install(){
    install_essential_dependencies
    download_plugin_repositories
    undeploy
    deploy
}

install_essential_dependencies() {
    echo_section "Installing essential softwares"
    local deps=''
    #git tmux zshがインストールされているかチェック
    if !(type git > /dev/null 2>&1); then
        deps="${deps} git"
    fi
    if !(type tmux > /dev/null 2>&1); then
        deps="${deps} tmux"
    fi
    if !(type zsh > /dev/null 2>&1); then
        deps="${deps} zsh"
    fi

    #全て入っている場合clone
    if [[ ${deps} = '' ]]; then
        clone_dotfiles_repository
        return
    fi

    #入っていないパッケージがある場合インストール
    if type apt > /dev/null 2>&1; then
        if [[ $(whoami) = 'root' ]]; then
            apt update
            apt install -y $deps
        else
            sudo apt update
            sudo apt install -y $deps
        fi
    elif type yum > /dev/null 2>&1; then
        if [[ $(whoami) = 'root' ]]; then
            yum install -y ${deps} || true
        else
            sudo yum install -y ${deps} || true
        fi
    fi

    clone_dotfiles_repository
}

clone_dotfiles_repository() {
    echo_section "Cloning dotfiles repository"
    if [[ ! -e $MYDOTFILES ]]; then
        git clone https://github.com/yugo1103/dotfiles $MYDOTFILES
    fi
}

download_plugin_repositories(){
    # install fzf
    if [[ ! -e ${FZFDIR} ]]; then
        echo_section "Downloading fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &
    fi

    # install zplug
    if [[ ! -e ${ZPLUGDIR} ]]; then
        echo_section "Downloading zplug"
        curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
    fi

#    if [[ ! -e ${OHMYZSHDIR} ]]; then
#        echo_section "Downloading oh my zsh"
#        git clone --depth 1 https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
#        pushd ~/.oh-my-zsh/custom/plugins
#            git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git &
#            git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions &
#            git clone --depth 1 https://github.com/zsh-users/zsh-completions &
#        popd
#
#        wait
#
#        if [[ ! -e ${OHMYZSHDIR}/custom/themes ]]; then
#            mkdir -p ${OHMYZSHDIR}/custom/themes
#        fi
#    fi

}

undeploy() {
    remove_rcfiles
}

remove_rcfiles() {
    echo_section "Removeing existing RC files"

    for rcfile in ${ZSHFILES[@]}; do
        name=$(basename $rcfile)
        remove_rcfiles_symlink "${ZDOTDIR:-$HOME}/${name}"
    done

    for item in ${SYMLINKS[@]}; do
        remove_rcfiles_symlink $item
    done
    unset item
}

remove_rcfiles_symlink() {
    if [[ -L $1 ]]; then
        echo "Removing symlink: $1"
        \unlink $1
    elif [[ -f $1 ]]; then
        echo "Removing normal file: $1"
        \rm -f $1
    else
        echo "$1 does not exists. Doing nothing."
    fi
}

deploy() {
    #deploy_zplug_files
    deploy_selfmade_rcfiles
    deploy_fzf
    compile_zshfiles
    install_vim_plugins

    git_configulation

    # Not symlink
    if [[ ! -e ${TMUXLOCAL} ]]; then
        mkdir -p $HOME/localrcs
        touch $HOME/localrcs/tmux-local
        echo "tmuxlocal is made"
    fi

    if [[ ! -e ${TRASH} ]]; then
        mkdir ${TRASH}
    fi
}

deploy_zplug_files() {
    echo_section "Installing zplug"

    for item in ${ZSHFILES[@]}; do
        # restore zshfiles backup if exists
        if [[ -e "${item}.bak0" ]]; then
            if [[ -e "${item}" ]]; then
                read -r -p "${item} already exists. Overwrite with ${item}.bak0? [y/N] " response
                case "$response" in
                    [yY][eE][sS]|[yY]) 
                        echo "Restore backup of ${item}"
                        cat ${item}.bak0 > ${item}
                        ;;
                    *)  ;;
                esac
            else
                echo "Restore backup of ${item}"
                cat ${item}.bak0 > ${item}
            fi
        fi
    done

    if [[ ! -e ${OHMYZSHDIR}/custom/themes/ishitaku.zsh-theme ]]; then
        ln -s $MYDOTFILES/zsh/ishitaku.zsh-theme ${OHMYZSHDIR}/custom/themes/
    fi

    # append line if zshrc doesn't has below line
    append_line 1 "source $MYDOTFILES/zsh/zshrc.zsh" "$HOME/.zshrc"
    insert_line 1 "skip_global_compinit=1" "$HOME/.zshenv"
}

deploy_selfmade_rcfiles() {
    # make symlinks
    echo_section "Installing RC files"
    final_idx_simlinks=$(expr ${#SYMLINKS[@]} - 1)
    for i in $(seq 0 ${final_idx_simlinks}); do
        if [[ ! -e ${SYMLINKS[${i}]} ]]; then
            mkdir -p $(dirname ${SYMTARGET[${i}]})
            touch ${SYMTARGET[${i}]}
            mkdir -p $(dirname ${SYMLINKS[${i}]})
            ln -s ${SYMTARGET[${i}]} ${SYMLINKS[${i}]}
            echo "Made link: ${SYMLINKS[${i}]}"
            echo "           --> ${SYMTARGET[${i}]}"
        else
            echo "${SYMLINKS[${i}]} already exists!!"
        fi
    done
}

deploy_fzf() {
    echo_section "Installing fzf"
    ~/.fzf/install --completion --key-bindings --update-rc
}

compile_zshfiles() {
    echo_section "Compiling zsh files"
    case $SHELL in
        */zsh) 
            # assume zsh
            $MYDOTFILES/tools/zsh_compile.zsh || true
            ;;
        *)
            if type zsh > /dev/null 2>&1; then
                zsh $MYDOTFILES/tools/zsh_compile.zsh || true
            else
                echo -e "\nCurrent shell is not zsh. skipping.\n"
            fi
    esac
}

install_vim_plugins() {
    echo_section "Installing vim plugins"

    export PATH=$PATH:$HOME/build/vim/bin

    if type vim > /dev/null 2>&1 && type git > /dev/null 2>&1; then
        if [[ ! -d $HOME/.vim/plugged ]]; then
            vim --not-a-term --cmd 'set shortmess=a cmdheight=2' -c ':PlugInstall --sync' -c ':qa!'
        fi
    fi
}

git_configulation() {
    echo_section "Configuring Git"
    git config --global core.editor vim
    git config --global alias.graph "log --graph --all --date=local --pretty=format:'%C(auto)%h%C(magenta) %cd %C(yellow)[%cr]%C(auto)%d%n    %C(auto)%s%n    %C(green)Committer:%cN <%cE>%n    %C(blue)Author   :%aN <%aE>%Creset'"
}

##############################################
#                    MAIN                    #
##############################################

#引数がない場合installを設定
if [[ $# -eq 0 ]]; then
    arg="install"
else
    arg=$1
fi

#引数のチェック
check_arguments ${arg}
ascii_art

if [[ ${arg} != "debug" ]]; then
    ${arg}
fi

echo -e "\nFINISHED!!!\n"
