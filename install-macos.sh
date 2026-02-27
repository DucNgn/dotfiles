#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

RESET='\033[0m'
BOLD='\033[1m'
BLUE='\033[34m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
MAGENTA='\033[35m'

info() {
  printf "${BLUE}[INFO]${RESET} %s\n" "$1"
}

ok() {
  printf "${GREEN}[OK]${RESET} %s\n" "$1"
}

warn() {
  printf "${YELLOW}[WARN]${RESET} %s\n" "$1"
}

err() {
  printf "${RED}[ERROR]${RESET} %s\n" "$1"
}

section() {
  printf "\n${MAGENTA}${BOLD}==> %s${RESET}\n\n" "$1"
}

run_section() {
  local name="$1"
  local fn="$2"
  section "$name"
  "$fn"
}

prompt_yes_no() {
  local prompt="$1"
  local answer
  while true; do
    printf "${CYAN}?${RESET} %s ${BOLD}[Y/N]${RESET}: " "$prompt"
    read -r answer
    case "$answer" in
      Y|y) return 0 ;;
      N|n) return 1 ;;
      *) printf "${YELLOW}Please enter Y or N.${RESET}\n" ;;
    esac
  done
}

require_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    err "Homebrew is required. Install it first: https://brew.sh"
    exit 1
  fi
}

require_npm() {
  if ! command -v npm >/dev/null 2>&1; then
    warn "npm is not installed."
    if command -v mise >/dev/null 2>&1; then
      if prompt_yes_no "Install Node.js (LTS) with mise now?"; then
        mise use -g node@lts
      fi
    else
      warn "mise is not installed, so automatic Node.js setup is unavailable."
    fi
  fi

  if ! command -v npm >/dev/null 2>&1; then
    warn "Install Node.js to use npm-based CLI installs."
    return 1
  fi
}

install_formula_if_needed() {
  local formula="$1"
  if brew list --formula "$formula" >/dev/null 2>&1; then
    ok "$formula is already installed."
  else
    if prompt_yes_no "$formula is not installed. Install it?"; then
      info "Installing $formula..."
      brew install "$formula"
      ok "$formula installed."
    else
      warn "Skipped installing $formula."
    fi
  fi
}

install_npm_global_if_needed() {
  local cmd_name="$1"
  local package_name="$2"

  if command -v "$cmd_name" >/dev/null 2>&1; then
    ok "$cmd_name is already installed."
    return 0
  fi

  if ! require_npm; then
    warn "Skipping $package_name install because npm is unavailable."
    return 1
  fi

  if prompt_yes_no "$package_name is not installed. Install it?"; then
    info "Installing $package_name..."
    npm install -g "$package_name"
    ok "$package_name installed."
  else
    warn "Skipped installing $package_name."
  fi
}

install_cask_if_needed() {
  local cask="$1"
  if brew list --cask "$cask" >/dev/null 2>&1; then
    ok "$cask is already installed."
  else
    if prompt_yes_no "$cask is not installed. Install it?"; then
      info "Installing $cask..."
      brew install --cask "$cask"
      ok "$cask installed."
    else
      warn "Skipped installing $cask."
    fi
  fi
}

config_status() {
  local src="$1"
  local dst="$2"

  if [ ! -e "$src" ]; then
    echo "no_repo_config"
    return 0
  fi

  if [ ! -e "$dst" ]; then
    echo "missing"
    return 0
  fi

  if [ -L "$dst" ]; then
    local src_real dst_real
    src_real="$(cd "$(dirname "$src")" && pwd -P)/$(basename "$src")"
    dst_real="$(cd "$(dirname "$dst")" && pwd -P)/$(basename "$dst")"
    if [ "$src_real" = "$dst_real" ]; then
      echo "match"
      return 0
    fi
  fi

  if cmp -s "$src" "$dst"; then
    echo "match"
  else
    echo "mismatch"
  fi
}

sync_config_link() {
  local src="$1"
  local dst="$2"
  local ts backup

  mkdir -p "$(dirname "$dst")"

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ]; then
      rm -f "$dst"
    else
      ts="$(date +%Y%m%d%H%M%S)"
      backup="${dst}.bak.${ts}"
      cp "$dst" "$backup"
      warn "Backed up existing config to $backup"
      rm -f "$dst"
    fi
  fi

  ln -s "$src" "$dst"
  ok "Linked $dst -> $src"
}

check_and_offer_config_sync() {
  local name="$1"
  local src="$2"
  local dst="$3"
  local status

  status="$(config_status "$src" "$dst")"
  case "$status" in
    no_repo_config)
      warn "$name has no config in this dotfiles repo to compare."
      ;;
    missing)
      warn "$name config is missing at $dst"
      if prompt_yes_no "Create link for $name config from dotfiles?"; then
        sync_config_link "$src" "$dst"
      fi
      ;;
    match)
      ok "$name config matches dotfiles."
      ;;
    mismatch)
      warn "$name config does not match dotfiles."
      if prompt_yes_no "Replace local $name config with dotfiles link?"; then
        sync_config_link "$src" "$dst"
      fi
      ;;
  esac
}

configure_tmux_entrypoint() {
  local tmux_entry="$HOME/.tmux.conf"
  local line='source-file ~/.config/tmux/tmux.conf'

  if [ -f "$tmux_entry" ] && grep -qxF "$line" "$tmux_entry"; then
    ok "tmux entrypoint already sources ~/.config/tmux/tmux.conf"
    return 0
  fi

  if prompt_yes_no "Set ~/.tmux.conf to source ~/.config/tmux/tmux.conf?"; then
    if [ -f "$tmux_entry" ]; then
      cp "$tmux_entry" "${tmux_entry}.bak.$(date +%Y%m%d%H%M%S)"
      warn "Backed up existing $tmux_entry"
    fi
    printf '%s\n' "$line" > "$tmux_entry"
    ok "Updated $tmux_entry"
  fi
}

configure_tpm() {
  local tpm_dir="$HOME/.config/tmux/plugins/tpm"
  if [ -d "$tpm_dir/.git" ]; then
    ok "TPM already installed."
    return 0
  fi
  if prompt_yes_no "Install tmux plugin manager (TPM)?"; then
    mkdir -p "$(dirname "$tpm_dir")"
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    ok "TPM installed."
  fi
}

install_tmux_plugins_with_tpm() {
  local install_script="$HOME/.config/tmux/plugins/tpm/bin/install_plugins"
  if [ ! -x "$install_script" ]; then
    warn "TPM install script not found at $install_script"
    return 0
  fi
  if prompt_yes_no "Install tmux plugins defined in tmux.conf via TPM now?"; then
    "$install_script"
    ok "tmux plugins installed via TPM."
  fi
}

install_and_configure_tmux() {
  install_formula_if_needed "tmux"
  check_and_offer_config_sync "tmux" \
    "$SCRIPT_DIR/.config/tmux/tmux.conf" \
    "$HOME/.config/tmux/tmux.conf"
  configure_tmux_entrypoint
  configure_tpm
  install_tmux_plugins_with_tpm
}

configure_alacritty_themes_repo() {
  local themes_dir="$HOME/.config/alacritty/themes"
  local themes_repo="$themes_dir/alacritty-theme"

  mkdir -p "$themes_dir"
  if [ -d "$themes_repo/.git" ]; then
    ok "alacritty-theme repo already exists at $themes_repo"
    if prompt_yes_no "Update alacritty-theme repo now?"; then
      info "Updating alacritty-theme repository..."
      git -C "$themes_repo" pull --ff-only
      ok "alacritty-theme updated."
    fi
  else
    if prompt_yes_no "alacritty-theme repo is missing. Install it now?"; then
      info "Cloning alacritty-theme repository..."
      git clone https://github.com/alacritty/alacritty-theme "$themes_repo"
      ok "alacritty-theme installed."
    fi
  fi
}

install_and_configure_alacritty() {
  ok "Assuming alacritty is already installed."
  check_and_offer_config_sync "alacritty" \
    "$SCRIPT_DIR/.config/alacritty/alacritty.toml" \
    "$HOME/.config/alacritty/alacritty.toml"
  configure_alacritty_themes_repo
}

install_and_configure_neovim() {
  install_formula_if_needed "neovim"
  warn "Neovim package only. LazyVim is handled in a separate step."
}

install_and_configure_lazyvim() {
  local nvim_dir="$HOME/.config/nvim"
  local lazyvim_marker="$nvim_dir/lazyvim.json"
  local starter_repo="https://github.com/LazyVim/starter"

  if [ -f "$lazyvim_marker" ]; then
    ok "LazyVim appears to be installed ($lazyvim_marker found)."
    if [ -d "$nvim_dir/.git" ] && prompt_yes_no "Update LazyVim starter repo now?"; then
      git -C "$nvim_dir" pull --ff-only || warn "Could not update LazyVim starter repo."
    fi
  else
    warn "LazyVim is not installed."
    if prompt_yes_no "Install LazyVim starter into ~/.config/nvim now?"; then
      mkdir -p "$HOME/.config"
      if [ -d "$nvim_dir" ] && [ -n "$(ls -A "$nvim_dir" 2>/dev/null)" ]; then
        local backup_dir="$HOME/.config/nvim.bak.$(date +%Y%m%d%H%M%S)"
        mv "$nvim_dir" "$backup_dir"
        warn "Backed up existing nvim config to $backup_dir"
      fi
      git clone "$starter_repo" "$nvim_dir"
      rm -rf "$nvim_dir/.git"
      ok "LazyVim starter installed at $nvim_dir"
    fi
  fi

  check_and_offer_config_sync "neovim" \
    "$SCRIPT_DIR/.config/nvim/init.lua" \
    "$HOME/.config/nvim/init.lua"
}

install_and_configure_fzf() {
  install_formula_if_needed "fzf"
  warn "No dedicated fzf config file in this repo to compare."
}

install_and_configure_direnv() {
  install_formula_if_needed "direnv"
  warn "No dedicated direnv config file in this repo to compare."
}

install_and_configure_github_cli() {
  install_formula_if_needed "gh"
  warn "No dedicated GitHub CLI config file in this repo to compare."
}

install_and_configure_victor_nerd_font() {
  install_cask_if_needed "font-victor-mono-nerd-font"
  warn "No dedicated Victor Mono Nerd Font config file in this repo to compare."
}

install_and_configure_mactex_no_gui() {
  install_cask_if_needed "mactex-no-gui"
  warn "No dedicated MacTeX config file in this repo to compare."
}

install_and_configure_codex_cli() {
  install_npm_global_if_needed "codex" "@openai/codex"
  check_and_offer_config_sync "codex" \
    "$SCRIPT_DIR/.codex/config.toml" \
    "$HOME/.codex/config.toml"
}

install_and_configure_claude_cli() {
  install_npm_global_if_needed "claude" "@anthropic-ai/claude-code"
  check_and_offer_config_sync "claude" \
    "$SCRIPT_DIR/.claude/settings.json" \
    "$HOME/.claude/settings.json"
}

install_and_configure_zsh() {
  if command -v zsh >/dev/null 2>&1; then
    ok "zsh is already installed."
  else
    install_formula_if_needed "zsh"
  fi
  check_and_offer_config_sync "zsh" \
    "$SCRIPT_DIR/.zshrc" \
    "$HOME/.zshrc"
}

install_and_configure_mise() {
  install_formula_if_needed "mise"
  warn "No dedicated mise config file in this repo to compare."
}

show_next_steps() {
  section "What's Next"
  if command -v codex >/dev/null 2>&1; then
    info "Configure Codex CLI auth: run 'codex' and follow login/setup prompts."
  else
    warn "Codex CLI not found. Re-run installer or install @openai/codex."
  fi

  if command -v claude >/dev/null 2>&1; then
    info "Configure Claude CLI auth: run 'claude' and complete login/setup."
  else
    warn "Claude CLI not found. Ensure npm/Node is installed, then re-run installer."
  fi

  info "Apply shell changes: open a new terminal or run 'source ~/.zshrc'."
  info "Open Neovim once ('nvim') to let LazyVim bootstrap plugins."
  info "If tmux is installed, open tmux and press Prefix+I to install TPM plugins."
}

main() {
  if [ "$(uname -s)" != "Darwin" ]; then
    err "This installer is for macOS only."
    exit 1
  fi

  require_brew

  section "macOS Dotfiles Installer"
  info "Installed tools are checked automatically."
  info "You will be prompted only for missing installs and config changes."

  run_section "mise" install_and_configure_mise
  run_section "zsh" install_and_configure_zsh
  run_section "tmux" install_and_configure_tmux
  run_section "alacritty" install_and_configure_alacritty
  run_section "neovim" install_and_configure_neovim
  run_section "lazyvim" install_and_configure_lazyvim
  run_section "fzf" install_and_configure_fzf
  run_section "direnv" install_and_configure_direnv
  run_section "GitHub CLI" install_and_configure_github_cli
  run_section "Victor Mono Nerd Font" install_and_configure_victor_nerd_font
  run_section "MacTeX (No GUI)" install_and_configure_mactex_no_gui
  run_section "OpenAI Codex CLI" install_and_configure_codex_cli
  run_section "Anthropic Claude CLI" install_and_configure_claude_cli

  section "Completed"
  ok "Installer finished."
  show_next_steps
}

main "$@"
