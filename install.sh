#!/bin/bash

dotfiles="$HOME/.dotfiles"

# link sublime user folder
echo "linking sublime user folder"
ln -s "$dotfiles/sublime" "$HOME/Library/Application Support/Sublime Text 3/Packages/User"
