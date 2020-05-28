#!/bin/bash

dotfiles="$HOME/.dotfiles"

if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew update

brew tap homebrew/bundle
brew bundle


# Install Oh-My-Zsh
ZSH=~/.oh-my-zsh

if [ -d "$ZSH" ]; then
  echo "Oh My Zsh is already installed. Skipping.."
else
  echo "Installing Oh My Zsh..."
  curl -L http://install.ohmyz.sh | sh
fi

rm $HOME/.zshrc
ln -s "$dotfiles/.zshrc" "$HOME/.zshrc"
source $HOME/.zshrc

ln -s "$dotfiles/iterm2/cobalt2.zsh-theme" "$HOME/.oh-my-zsh/themes/cobalt2.zsh-theme"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py

## Install powerline
pip install --user powerline-status
git clone https://github.com/powerline/fonts
cd fonts
./install.sh
cd ..
sudo rm -R fonts

# Set default MySQL root password and auth type.
mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

# Install global Composer packages
/usr/local/bin/composer global require laravel/installer laravel/spark-installer laravel/valet tightenco/tlint

# Install Laravel Valet
$HOME/.composer/vendor/bin/valet install

# link sublime user folder
echo "linking sublime user folder"
ln -s "$dotfiles/sublime" "$HOME/Library/Application Support/Sublime Text 3/Packages/User"

mkdir $HOME/bin
ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" $HOME/bin/subl

mkdir $HOME/Code

# Enable key repeat in Sublime
defaults write com.sublimetext.3 ApplePressAndHoldEnabled -bool false

# link karabiner config
echo "linking karabiner config"
ln -s "$dotfiles/karabiner/karabiner.edn" "$HOME/.config/karabiner.edn"

# link hammerspoon config
echo "linking hammerspoon config"
ln -s "$dotfiles/hammerspoon" "$HOME/.hammerspoon"

echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Enable tap to click. (Don't have to press down on the trackpad -- just tap it.)
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Bottom right screen corner → Start screen saver
defaults write com.apple.dock wvous-bl-corner -int 5

# install npm packages in home directory
echo "moving npm global install directory to home folder"
mkdir "${HOME}/.npm-packages"
ln -s "$dotfiles/npm/.npmrc" "${HOME}/.npmrc"

echo "installing global npm packages"
npm install -g eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react
npm install -g fx
npm install -g gulp
npm install -g @vue/cli

# list globally installed packages
npm -g list --depth=0

# Symlink the Mackup config file to the home directory
ln -s $dotfiles/.mackup.cfg $HOME/.mackup.cfg
