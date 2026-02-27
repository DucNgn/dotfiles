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
