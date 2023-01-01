#!/usr/bin/sh

MODERN_NEOVIM=~/.config/modern-neovim
export MODERN_NEOVIM

alias mnv='XDG_DATA_HOME=$MODERN_NEOVIM/share XDG_CACHE_HOME=$MODERN_NEOVIM XDG_CONFIG_HOME=$MODERN_NEOVIM nvim'

mnv
