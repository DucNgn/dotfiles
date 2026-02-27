# Dotfiles

+ Lazyvim / Vim
+ Tmux
+ Alacritty

## Setup

### Alacritty

The config (`alacritty.toml`) uses the [alacritty-theme](https://github.com/alacritty/alacritty-theme) collection. Clone it into the expected location:

```sh
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
```

### Tmux

The tmux config is at `~/.config/tmux/tmux.conf` and uses [TPM](https://github.com/tmux-plugins/tpm) for plugins.

Install TPM:

```sh
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

### macOS Installer

Run the interactive macOS installer (assumes Homebrew is already installed):

```sh
./install-macos.sh
```

It prompts per tool and can install/configure `mise`, `zsh`, `tmux`, `neovim`, `lazyvim`, `fzf`, `direnv`, `gh` (GitHub CLI), `font-victor-mono-nerd-font`, `mactex-no-gui`, OpenAI Codex CLI, and Anthropic Claude CLI.
For `alacritty`, it assumes the app is already installed and only manages config/themes.
For tmux, it can install TPM and then install tmux plugins.
For alacritty, it can install/update the `alacritty-theme` repo under `~/.config/alacritty/themes/alacritty-theme`.
