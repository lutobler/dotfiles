#!/usr/bin/env bash

stow_cmd="stow -v -t $HOME -d $PWD/stow"

echo 'symlinking config files ...'
$stow_cmd vim
$stow_cmd vis
$stow_cmd xorg
$stow_cmd bash
$stow_cmd dunst
$stow_cmd redshift
$stow_cmd herbstluftwm
$stow_cmd nvim
$stow_cmd xdg-user-dirs
