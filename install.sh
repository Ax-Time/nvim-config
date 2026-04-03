#!/usr/bin/env bash
set -e

REPO_URL="${REPO_URL:-git@github.com:Ax-Time/nvim-config.git}"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

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

# Check/install Go (required for gopls)
check_go() {
    if command -v go &>/dev/null; then
        local version=$(go version | awk '{print $3}')
        echo "Go $version found"
        return 0
    fi
    return 1
}

install_go() {
    local os=$1
    echo "Installing Go..."

    case $os in
        macos)
            if command -v brew &>/dev/null; then
                brew install go
            else
                echo "Error: Homebrew not found. Install from https://brew.sh"
                exit 1
            fi
            ;;
        linux-apt)
            local goversion="go1.22.3"
            local arch=$(uname -m)
            [ "$arch" = "x86_64" ] && arch="amd64" || [ "$arch" = "aarch64" ] && arch="arm64"
            wget -q "https://go.dev/dl/${goversion}.linux-${arch}.tar.gz" -O /tmp/go.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf /tmp/go.tar.gz
            rm /tmp/go.tar.gz
            ;;
        linux-dnf)
            sudo dnf install -y golang
            ;;
        *)
            echo "Error: Unsupported OS for Go installation"
            exit 1
            ;;
    esac

    if ! check_go; then
        echo "Error: Go installation verification failed"
        echo "You may need to restart your shell or run: export PATH=\$PATH:/usr/local/go/bin"
        return 1
    fi
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

set +e
if ! check_go; then
    set -e
    install_go "$OS"
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

echo ""
echo "Installation complete!"
echo "Run 'nvim' to start - plugins will install automatically on first run."