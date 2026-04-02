#!/usr/bin/env bash
set -e

REPO_URL="${REPO_URL:-https://github.com/axtime/nvim-config}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
NVIM_MIN_VERSION="0.9"

echo "Installing Neovim config from $REPO_URL"

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)
            if command -v apt &>/dev/null; then echo "linux-apt"
            elif command -v dnf &>/dev/null; then echo "linux-dnf"
            elif command -v pacman &>/dev/null; then echo "linux-pacman"
            else echo "unsupported"
            fi
            ;;
        *) echo "unsupported" ;;
    esac
}

# Check/install Neovim
check_nvim() {
    if command -v nvim &>/dev/null; then
        local version=$(nvim --version | head -1 | awk '/[0-9]+\.[0-9]+/ {match($0, /[0-9]+\.[0-9]+/); print substr($0, RSTART, RLENGTH); exit}')
        if [ -n "$version" ]; then
            echo "Neovim $version found"
            return 0
        fi
    fi
    return 1
}

install_nvim() {
    local os=$1
    echo "Installing Neovim..."

    case $os in
        macos)
            if command -v brew &>/dev/null; then
                brew install neovim
            else
                echo "Error: Homebrew not found. Install from https://brew.sh"
                exit 1
            fi
            ;;
        linux-apt)
            sudo apt update && sudo apt install -y neovim
            ;;
        linux-dnf)
            sudo dnf install -y neovim
            ;;
        linux-pacman)
            sudo pacman -S --noconfirm neovim
            ;;
        *)
            echo "Error: Unsupported OS"
            exit 1
            ;;
    esac
}

# Main
OS=$(detect_os)
if [ "$OS" = "unsupported" ]; then
    echo "Error: Unsupported operating system"
    exit 1
fi

set +e
if ! check_nvim; then
    set -e
    install_nvim "$OS"
    if ! check_nvim; then
        echo "Error: Neovim installation verification failed"
        exit 1
    fi
fi
set -e

# Backup existing config
if [ -d "$CONFIG_DIR" ]; then
    BACKUP_DIR="${CONFIG_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up existing config to $BACKUP_DIR"
    mv "$CONFIG_DIR" "$BACKUP_DIR"
fi

# Clone repo
echo "Cloning config to $CONFIG_DIR"
if ! git clone "$REPO_URL" "$CONFIG_DIR"; then
    echo "Error: Failed to clone repository"
    exit 1
fi

# Install plugins
echo "Installing plugins..."
set +e
nvim --headless "+Lazy! sync" +qa
if [ $? -ne 0 ]; then
    set -e
    echo "Error: Failed to install plugins"
    exit 1
fi
set -e

echo ""
echo "Installation complete! Run 'nvim' to start."
