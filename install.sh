#!/bin/bash

dotfiles="$HOME/.dotfiles"

# link sublime user folder
echo "linking sublime user folder"
ln -s "$dotfiles/sublime" "$HOME/Library/Application Support/Sublime Text 3/Packages/User"

# link karabiner config
echo "linking karabiner config"
ln -s "$dotfiles/karabiner/karabiner.edn" "$HOME/.config/karabiner.edn"

# link hammerspoon config
echo "linking hammerspoon config"
ln -s "$dotfiles/hammerspoon" "$HOME/.hammerspoon"

echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# install npm packages in home directory
echo "moving npm global install directory to home folder"
mkdir "${HOME}/.npm-packages"
ln -s "$dotfiles/npm/.npmrc" "${HOME}/.npmrc"

echo "installing global npm packages"
npm install -g eslint eslint-config-airbnb eslint-plugin-import eslint-plugin-jsx-a11y eslint-plugin-react
npm install -g fx
npm install -g gulp
npm install -g @vue/cli
npm install -g yarn

# list globally installed packages
npm -g list --depth=0
