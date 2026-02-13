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

# Check if package is installed via Homebrew
check_package_exists() {
    local package=$1
    brew list "$package" &>/dev/null
}

# Install a package via Homebrew
install_package() {
    local package=$1
    local is_cask=${2:-false}

    if check_package_exists "$package"; then
        print_success "$package is already installed"
        return 0
    fi

    print_info "Installing $package..."
    if [ "$is_cask" = true ]; then
        brew install --cask "$package" || {
            print_error "Failed to install $package"
            return 1
        }
    else
        brew install "$package" || {
            print_error "Failed to install $package"
            return 1
        }
    fi
    print_success "$package installed successfully"
}

# Setup functions
setup_neovim() {
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

setup_zsh() {
    print_info "Setting up Zsh..."

    if [ -f "$SCRIPT_DIR/.zshrc" ]; then
        print_info "Copying .zshrc..."
        cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc" || {
            print_error "Failed to copy .zshrc"
            return 1
        }
        print_success ".zshrc copied to $HOME"
    else
        print_warning "No .zshrc found in $SCRIPT_DIR"
    fi
}

setup_tmux() {
    print_info "Setting up Tmux..."

    mkdir -p "$HOME/.config/tmux"

    if [ -f "$SCRIPT_DIR/config/tmux/tmux.conf" ]; then
        print_info "Copying tmux.conf..."
        cp "$SCRIPT_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf" || {
            print_error "Failed to copy tmux.conf"
            return 1
        }
        print_success "tmux.conf copied to $HOME/.config/tmux"
    else
        print_warning "No tmux.conf found in $SCRIPT_DIR/config/tmux"
    fi
}

# Preflight checks
preflight_checks() {
    print_info "Running preflight checks..."

    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed"
        print_info "Install Homebrew from https://brew.sh"
        exit 1
    fi

    print_success "Homebrew is installed"
}

# Install category: CLI Utilities
install_cli_utilities() {
    print_info ""
    print_info "Installing CLI Utilities..."

    local packages=("tmux" "fzf" "htop")
    local failed=0

    for package in "${packages[@]}"; do
        install_package "$package" || failed=$((failed + 1))
    done

    return $failed
}

# Install category: System Tools
install_system_tools() {
    print_info ""
    print_info "Installing System Tools..."

    # nslookup comes with bind, nstool doesn't exist, skipping nstool
    local packages=("bind")
    local failed=0

    for package in "${packages[@]}"; do
        install_package "$package" || failed=$((failed + 1))
    done

    return $failed
}

# Install category: Text Editors & Development
install_development_tools() {
    print_info ""
    print_info "Installing Text Editors & Development Tools..."

    local failed=0

    # Install neovim
    install_package "neovim" || failed=$((failed + 1))

    # Setup neovim with lazyvim
    if [ $failed -eq 0 ]; then
        setup_neovim || failed=$((failed + 1))
    fi

    # Install zsh
    install_package "zsh" || failed=$((failed + 1))

    # Setup zsh
    if [ $failed -eq 0 ]; then
        setup_zsh || failed=$((failed + 1))
    fi

    # Install tmux
    install_package "tmux" || failed=$((failed + 1))

    # Setup tmux
    if [ $failed -eq 0 ]; then
        setup_tmux || failed=$((failed + 1))
    fi

    # Install claude-code
    install_package "claude-code" true || failed=$((failed + 1))

    return $failed
}

# Main installation flow
main() {
    print_info ""
    print_info "macOS Installation Script"
    print_info "=========================="

    preflight_checks

    print_info ""
    print_info "Select which categories to install:"
    print_info ""

    # Prompt for each category
    read -p "Install CLI Utilities (tmux, fzf, htop)? (y/n): " -r cli_choice
    read -p "Install System Tools (bind/nslookup)? (y/n): " -r sys_choice
    read -p "Install Text Editors & Development (neovim, zsh, tmux, claude-code)? (y/n): " -r dev_choice

    print_info ""

    # Install selected categories with retry logic
    if [[ $cli_choice =~ ^[Yy]$ ]]; then
        while true; do
            if install_cli_utilities; then
                break
            else
                print_warning "CLI Utilities installation had errors"
                read -p "Retry CLI Utilities? (y/n): " -r retry_choice
                if [[ ! $retry_choice =~ ^[Yy]$ ]]; then
                    break
                fi
            fi
        done
    fi

    if [[ $sys_choice =~ ^[Yy]$ ]]; then
        while true; do
            if install_system_tools; then
                break
            else
                print_warning "System Tools installation had errors"
                read -p "Retry System Tools? (y/n): " -r retry_choice
                if [[ ! $retry_choice =~ ^[Yy]$ ]]; then
                    break
                fi
            fi
        done
    fi

    if [[ $dev_choice =~ ^[Yy]$ ]]; then
        while true; do
            if install_development_tools; then
                break
            else
                print_warning "Text Editors & Development installation had errors"
                read -p "Retry Text Editors & Development? (y/n): " -r retry_choice
                if [[ ! $retry_choice =~ ^[Yy]$ ]]; then
                    break
                fi
            fi
        done
    fi

    print_info ""
    print_success "Installation complete!"
}

# Trap ctrl+c
trap 'echo ""; print_warning "Installation cancelled"; exit 0' INT

main
