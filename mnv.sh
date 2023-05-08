#!/usr/bin/sh

# https://github.com/neovim/neovim/pull/22128
MNV_APP_NAME=modern-neovim
alias mnv="NVIM_APPNAME=$MNV_APP_NAME nvim"
mnv
