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

Then symlink or copy `alacritty.toml` to `~/.config/alacritty/alacritty.toml`.
