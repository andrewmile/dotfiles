#!/bin/bash

dotfiles="$HOME/.dotfiles"

# link sublime user folder
echo "linking sublime user folder"
ln -s "$dotfiles/sublime" "$HOME/Library/Application Support/Sublime Text 3/Packages/User"

echo "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
