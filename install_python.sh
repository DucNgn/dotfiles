#!/bin/bash
echo "Installing pyenv"
brew install pyenv
echo
echo "Installing Dependencies"
brew install zlib
brew install sqlite
brew install bzip2
brew install libiconv
brew install libzip
echo "Done!"
echo
echo -e "Setting Environment Variables"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/sqlite/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/sqlite/lib/pkgconfig"
echo "Done!"
echo
echo "Installing Python 3.9.15"
pyenv install 3.9.15
echo "Adding pyenv to path"
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
echo "Done!"
echo
echo "Installing and configuring Poetry"
brew install poetry
poetry config virtualenvs.in-project true
echo "Done! Restart or source .zshrc for the changes to take effect"
exit 0
