#!/bin/sh

MODERN_NEOVIM=~/.config/modern-neovim
export MODERN_NEOVIM

rm -rf "$MODERN_NEOVIM"

mkdir -p "$MODERN_NEOVIM"/share
mkdir -p "$MODERN_NEOVIM"/nvim

stow --restow --target="$MODERN_NEOVIM"/nvim .

alias mnv='XDG_DATA_HOME=$MODERN_NEOVIM/share XDG_CACHE_HOME=$MODERN_NEOVIM XDG_CONFIG_HOME=$MODERN_NEOVIM nvim'
