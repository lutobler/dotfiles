#!/usr/bin/env bash

stow_cmd="stow -v -t $HOME -d $PWD/stow"

echo 'symlinking config files ...'
$stow_cmd redshift
$stow_cmd herbstluftwm
$stow_cmd nvim
$stow_cmd termite
$stow_cmd home
$stow_cmd polybar
$stow_cmd xdg-user-dirs
$stow_cmd xresources

ln -sf $HOME/.config/nvim/init.vim $HOME/.vimrc
