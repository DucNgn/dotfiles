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

# Package manager detection
PKG_MANAGER=""

# Run command with sudo if needed
run_with_sudo() {
    if [ "$(id -u)" -eq 0 ]; then
        # Already root, run directly
        "$@"
    elif command -v sudo &> /dev/null; then
        # Not root but sudo exists
        sudo "$@"
    else
        # Not root and sudo doesn't exist, try running anyway
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

# Check if package is installed
check_package_exists() {
    local package=$1

    if [ "$PKG_MANAGER" = "apt" ]; then
        dpkg -l | grep -q "^ii  $package" 2>/dev/null
    elif [ "$PKG_MANAGER" = "apk" ]; then
        apk info 2>/dev/null | grep -q "^$package" 2>/dev/null
    fi
}

# Install a package
install_package() {
    local package=$1

    if check_package_exists "$package"; then
        print_success "$package is already installed"
        return 0
    fi

    print_info "Installing $package..."

    if [ "$PKG_MANAGER" = "apt" ]; then
        run_with_sudo apt-get install -y "$package" || {
            print_error "Failed to install $package"
            return 1
        }
    elif [ "$PKG_MANAGER" = "apk" ]; then
        run_with_sudo apk add "$package" || {
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

    # Detect package manager
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt"
        print_success "Detected apt (Debian/Ubuntu)"
    elif command -v apk &> /dev/null; then
        PKG_MANAGER="apk"
        print_success "Detected apk (Alpine Linux)"
    else
        print_error "No supported package manager found (apt or apk)"
        print_info "This script supports Debian/Ubuntu and Alpine Linux"
        exit 1
    fi

    # Check if running as root or have sudo access
    if [ "$EUID" -ne 0 ] && ! sudo -n true 2>/dev/null; then
        print_warning "This script requires elevated privileges to install packages"
        print_info "You may be prompted for your password"
    fi
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

    # Setup tmux config after installation
    if [ $failed -eq 0 ]; then
        setup_tmux || failed=$((failed + 1))
    fi

    return $failed
}

# Install category: System Tools
install_system_tools() {
    print_info ""
    print_info "Installing System Tools..."

    local package
    local failed=0

    # Different package names for different package managers
    if [ "$PKG_MANAGER" = "apt" ]; then
        package="dnsutils"  # provides nslookup
    elif [ "$PKG_MANAGER" = "apk" ]; then
        package="bind-tools"  # provides nslookup
    fi

    install_package "$package" || failed=$((failed + 1))

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

    print_info "Installing Claude Code..."
    print_warning "Claude Code installation requires manual setup on Linux"
    print_info "Visit https://claude.com/download for installation instructions"

    return $failed
}

# Main installation flow
main() {
    print_info ""
    print_info "Linux Installation Script"
    print_info "========================="

    preflight_checks

    print_info ""
    print_info "Select which categories to install:"
    print_info ""

    # Prompt for each category
    read -p "Install CLI Utilities (tmux, fzf, htop)? (y/n): " -r cli_choice
    read -p "Install System Tools (dnsutils/nslookup)? (y/n): " -r sys_choice
    read -p "Install Text Editors & Development (neovim, zsh, tmux)? (y/n): " -r dev_choice

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
