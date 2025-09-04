#!/bin/bash
#
# Andrey A. Ugolnik
# https://www.ugolnik.info
# andrey@ugolnik.info
#

# --- common vars --------------------------------------------------------------

CWD=$(pwd)
UNAME=$(uname -s)

# --- list of configs to install -----------------------------------------------

CONFIG_DIR=${XDG_CONFIG_HOME:-$HOME/.config}
if [ ! -d $CONFIG_DIR ]; then
    mkdir $CONFIG_DIR
fi

CONFIGS_LIST=(
    wezterm
    # kitty
    # alacritty
    tmux
    nvim
    vim
    vifm
    zsh
    # bash
    # lazygit
)

# --- list of tools to install -------------------------------------------------
BREW_TOOLS_LIST=(
    wezterm
    tmux
    nvim
    vifm
    zoxide
    fd
    ripgrep
    fzf
    7zip
)

# --- macOS: brew --------------------------------------------------------------

helpBrewNotInstalled() {
    echo ""
    echo "-------------------------------------------------"
    echo "|                                               |"
    echo "|           Homebrew isn't installed            |"
    echo "|                                               |"
    echo "-------------------------------------------------"

    echo ""
    echo "Next steps:"
    echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""

    echo ""
    echo "Then run 'bottstrap.sh' again."
    echo ""
}

if [ $UNAME = "Darwin" ]; then
    echo ""
    echo "-------------------------------------------------"
    echo "|                                               |"
    echo "|                macOS detected                 |"
    echo "|                                               |"
    echo "-------------------------------------------------"

    # install brew
    if ! command -v brew &>/dev/null; then
        helpBrewNotInstalled
        exit
    fi

    # install tools
    echo ""
    echo "-------------------------------------------------"
    echo "|                                               |"
    echo "|               installing tools                |"
    echo "|                                               |"
    echo "-------------------------------------------------"

    for i in "${BREW_TOOLS_LIST[@]}"; do
        brew install $i
    done
fi

# --- install zsh --------------------------------------------------------------

helpZshNotInstalled() {
    echo ""
    echo "-------------------------------------------------"
    echo "|                                               |"
    echo "|           Oh My Zsh isn't installed           |"
    echo "|                                               |"
    echo "-------------------------------------------------"

    echo ""
    echo "Next steps:"
    echo "  sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    echo "  exit"
    echo "  source ~/.zshrc"

    echo ""
    echo "Then run 'bottstrap.sh' again."
    echo ""
}

if [ -z ${ZSH+x} ]; then
    helpZshNotInstalled
    exit
fi

if [ ! -d "$ZSH" ]; then
    helpZshNotInstalled
    exit
fi

# --- zsh plugins --------------------------------------------------------------

ZSH_CUSTOM=${ZSH_CUSTOM:-$ZSH/custom}

echo ""
echo "-------------------------------------------------"
echo "|                                               |"
echo "|         Installing Oh My Zsh plugins          |"
echo "|                                               |"
echo "-------------------------------------------------"

zshPluginInstallUpdate() {
    PLUG_URL=$1
    PLUG_PATH=$ZSH_CUSTOM/$2
    if [ ! -d $PLUG_PATH ]; then
        echo "* Cloning $2..."
        git clone $PLUG_URL $PLUG_PATH
    else
        echo "* Updating $2..."
        cd $PLUG_PATH && git pull -p >/dev/null
        cd - >/dev/null
    fi
}

# install PowerLevel10K theme
zshPluginInstallUpdate "https://github.com/romkatv/powerlevel10k.git" "themes/powerlevel10k"

# install zsh-autosuggestions
zshPluginInstallUpdate "https://github.com/zsh-users/zsh-autosuggestions" "plugins/zsh-autosuggestions"

# install zsh-syntax-highlighting
zshPluginInstallUpdate "https://github.com/zsh-users/zsh-syntax-highlighting.git" "plugins/zsh-syntax-highlighting"

# --- clone or update ----------------------------------------------------------

echo ""
echo "-------------------------------------------------"
echo "|                                               |"
echo "|           Cloning/Updating configs            |"
echo "|                                               |"
echo "-------------------------------------------------"

for i in "${CONFIGS_LIST[@]}"; do
    cd $CWD
    if [ ! -d "config-$i" ]; then
        echo "* Cloning config-$i..."
        git clone git@github.com:reybits/config-$i.git &&
            cd "config-$i" &&
            git submodule update --init
    else
        echo "* Updating config-$i..."
        cd "config-$i" &&
            git pull -p >/dev/null &&
            git submodule update --init >/dev/null
    fi
done

cd $CWD

# ---  make links --------------------------------------------------------------

echo ""
echo "-------------------------------------------------"
echo "|                                               |"
echo "|                Setting links                  |"
echo "|                                               |"
echo "-------------------------------------------------"

for i in "${CONFIGS_LIST[@]}"; do
    if [[ -d "$CONFIG_DIR/$i" && ! -L "$CONFIG_DIR/$i" ]]; then
        echo "* Moving: '$CONFIG_DIR/$i' to '$CONFIG_DIR/$i-old'"
        mv "$CONFIG_DIR/$i" "$CONFIG_DIR/$i-old"
    fi

    if [[ $i != "vim" ]]; then
        ln -s -i "$CWD/config-$i/$i" "$CONFIG_DIR"
    fi
done

# make .vim link
ln -s -i "$CWD/config-vim/vim" ~/.vim

# make .zshrc link
ln -s -i "$CWD/config-zsh/.zshrc" ~/.zshrc

# --- print next steps ---------------------------------------------------------

echo ""
echo "-------------------------------------------------"
echo "|                                               |"
echo "|                 Almost done                   |"
echo "|                                               |"
echo "-------------------------------------------------"

echo ""
echo "Next steps:"
echo "  source ~/.zshrc"

echo ""
echo "Then follow these steps:"
echo "1. Configure zsh theme: run 'p10k configure'"
echo "2. Start tmux: run 'tmux', then press 'prefix + I' to install plugins."
echo ""
