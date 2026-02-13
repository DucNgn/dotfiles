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

# Setup tmux config
setup_tmux() {
    print_info "Setting up Tmux configuration..."

    mkdir -p "$HOME/.config/tmux"

    local tmux_conf_path="$SCRIPT_DIR/tmux.conf"

    if [ -f "$tmux_conf_path" ]; then
        print_info "Copying tmux.conf..."
        cp "$tmux_conf_path" "$HOME/.config/tmux/tmux.conf" || {
            print_error "Failed to copy tmux.conf to ~/.config/tmux"
            return 1
        }
        cp "$tmux_conf_path" "$HOME/.tmux.conf" || {
            print_error "Failed to copy tmux.conf to home folder"
            return 1
        }
        print_success "tmux.conf copied to ~/.config/tmux and ~/.tmux.conf"

        # Install tpm plugins if tpm is installed
        if [ -f "$HOME/.tmux/plugins/tpm/bin/install_plugins" ]; then
            print_info "Installing tmux plugins..."
            "$HOME/.tmux/plugins/tpm/bin/install_plugins" || {
                print_warning "Failed to install tmux plugins (this may be normal if tpm needs to be cloned first)"
            }
        fi

        # Reload tmux config
        if command -v tmux &> /dev/null; then
            print_info "Reloading tmux config..."
            tmux source-file "$HOME/.tmux.conf" 2>/dev/null || {
                print_warning "Could not reload tmux (no active tmux session, it will reload on next session start)"
            }
            print_success "Tmux config reloaded"
        fi
    else
        print_error "No tmux.conf found in $SCRIPT_DIR"
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
