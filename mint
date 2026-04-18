#!/usr/bin/env zsh
if [[ -z $STOW_FOLDERS ]]; then
    STOW_FOLDERS="bin,nvim,tmux,zsh,i3,alacritty,git,ssh,matplotlib"
fi

if [[ -z $DOTFILES ]]; then
    DOTFILES=$HOME/.dotfiles
fi

STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES $DOTFILES/install
