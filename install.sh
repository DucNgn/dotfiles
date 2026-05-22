#!/bin/bash

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run command with appropriate privileges
run_cmd() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo &> /dev/null; then
        sudo "$@"
    else
        "$@"
    fi
}

# Helper functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Detect package manager and install neovim
install_neovim() {
    print_info "Checking for neovim..."

    if command -v nvim &> /dev/null; then
        print_success "Neovim is already installed"
        return 0
    fi

    print_info "Installing neovim..."

    if command -v apk &> /dev/null; then
        run_cmd apk add neovim || {
            print_error "Failed to install neovim"
            return 1
        }
    elif command -v apt-get &> /dev/null; then
        run_cmd apt-get update
        run_cmd apt-get install -y neovim || {
            print_error "Failed to install neovim"
            return 1
        }
    else
        print_error "No supported package manager found (apt or apk)"
        return 1
    fi

    print_success "Neovim installed successfully"
}

# Setup neovim with lazyvim
setup_lazyvim() {
    print_info "Setting up Neovim with LazyVim..."

    # Create .config/nvim if it doesn't exist
    mkdir -p "$HOME/.config/nvim"

    # Clone lazyvim if it doesn't exist
    if [ ! -d "$HOME/.config/nvim/.git" ]; then
        print_info "Cloning LazyVim..."
        git clone https://github.com/LazyVim/starter "$HOME/.config/nvim" || {
            print_error "Failed to clone LazyVim"
            return 1
        }
    fi

    # Copy user's lazyvim config
    if [ -d "$SCRIPT_DIR/config/nvim" ]; then
        print_info "Copying your LazyVim configuration..."
        cp -r "$SCRIPT_DIR/config/nvim"/* "$HOME/.config/nvim/" || {
            print_error "Failed to copy LazyVim config"
            return 1
        }
        print_success "LazyVim configuration copied"
    else
        print_warning "No LazyVim config found in $SCRIPT_DIR/config/nvim"
    fi
}

# Setup alacritty config
setup_alacritty() {
    print_info "Setting up Alacritty configuration..."

    mkdir -p "$HOME/.config/alacritty/themes"

    if [ -d "$SCRIPT_DIR/config/alacritty" ]; then
        cp "$SCRIPT_DIR/config/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml" || {
            print_error "Failed to copy alacritty.toml"
            return 1
        }
        cp "$SCRIPT_DIR/config/alacritty/themes/"*.toml "$HOME/.config/alacritty/themes/" 2>/dev/null || true
        print_success "Alacritty configuration copied"
    else
        print_warning "No Alacritty config found in $SCRIPT_DIR/config/alacritty"
    fi
}

# Setup pi themes
setup_pi_themes() {
    print_info "Setting up pi themes..."

    mkdir -p "$HOME/.pi/agent/themes"

    if [ -d "$SCRIPT_DIR/config/pi/themes" ]; then
        for f in "$SCRIPT_DIR/config/pi/themes/"*.json; do
            local name=$(basename "$f")
            local target="$HOME/.pi/agent/themes/$name"
            rm -f "$target"
            ln -s "$f" "$target"
            print_success "Linked pi theme: $name"
        done
    else
        print_warning "No pi themes found in $SCRIPT_DIR/config/pi/themes"
    fi
}

# Setup theme-toggle
setup_theme_toggle() {
    print_info "Setting up theme-toggle..."

    local src="$SCRIPT_DIR/bin/theme-toggle"
    if [ -f "$src" ]; then
        mkdir -p "$HOME/.local/bin"
        cp "$src" "$HOME/.local/bin/theme-toggle"
        chmod +x "$HOME/.local/bin/theme-toggle"
        print_success "theme-toggle installed to ~/.local/bin/theme-toggle"
    else
        print_warning "No theme-toggle found in $SCRIPT_DIR/bin"
    fi
}

# Setup zshrc
setup_zshrc() {
    print_info "Setting up .zshrc..."

    if [ -f "$SCRIPT_DIR/zshrc" ]; then
        cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc" || {
            print_error "Failed to copy .zshrc"
            return 1
        }
        print_success ".zshrc copied to ~/.zshrc"
    else
        print_error "No zshrc found in $SCRIPT_DIR"
        return 1
    fi
}

# Setup tmux config
setup_tmux() {
    print_info "Setting up Tmux configuration..."

    mkdir -p "$HOME/.config/tmux"

    local tmux_conf_path="$SCRIPT_DIR/config/tmux/tmux.conf"

    if [ -f "$tmux_conf_path" ]; then
        print_info "Copying tmux.conf..."
        cp "$tmux_conf_path" "$HOME/.config/tmux/tmux.conf" || {
            print_error "Failed to copy tmux.conf to ~/.config/tmux"
            return 1
        }
        print_success "tmux.conf copied to ~/.config/tmux/tmux.conf"

        # Clone tpm if not present
        if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
            print_info "Cloning tpm..."
            git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm" || {
                print_warning "Failed to clone tpm"
            }
        fi

        # Install tpm plugins
        if [ -f "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" ]; then
            print_info "Installing tmux plugins..."
            "$HOME/.config/tmux/plugins/tpm/bin/install_plugins" || {
                print_warning "Failed to install tmux plugins"
            }
        fi

        # Reload tmux config
        if command -v tmux &> /dev/null; then
            print_info "Reloading tmux config..."
            tmux source-file "$HOME/.config/tmux/tmux.conf" 2>/dev/null || {
                print_warning "Could not reload tmux (no active tmux session, it will reload on next session start)"
            }
            print_success "Tmux config reloaded"
        fi
    else
        print_error "No tmux.conf found in $SCRIPT_DIR/config/tmux"
        return 1
    fi
}

# Main
main() {
    print_info ""
    print_info "Coder Environment Setup"
    print_info "======================="
    print_info ""

    local failed=0

    # Install neovim
    install_neovim || failed=$((failed + 1))

    # Setup lazyvim
    if [ $failed -eq 0 ]; then
        setup_lazyvim || failed=$((failed + 1))
    fi

    # Setup alacritty
    setup_alacritty || failed=$((failed + 1))

    # Setup pi themes
    setup_pi_themes || failed=$((failed + 1))

    # Setup theme-toggle
    setup_theme_toggle || failed=$((failed + 1))

    # Setup zshrc
    setup_zshrc || failed=$((failed + 1))

    # Setup tmux config
    if [ $failed -eq 0 ]; then
        setup_tmux || failed=$((failed + 1))
    fi

    print_info ""
    if [ $failed -eq 0 ]; then
        print_success "Coder environment setup complete!"
    else
        print_error "Setup completed with errors"
        exit 1
    fi
}

# Trap ctrl+c
trap 'echo ""; print_info "Setup cancelled"; exit 0' INT

main
