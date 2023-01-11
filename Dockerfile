FROM alpine:latest AS base

RUN apk --no-cache add \
  autoconf \
  automake \
  build-base \
  cmake \
  ninja \
  coreutils \
  curl \
  gettext-tiny-dev \
  git \
  libtool \
  pkgconf \
  unzip \
  stow \
  npm

# Build neovim (and use it as an example codebase
RUN git clone https://github.com/neovim/neovim.git

ARG VERSION=master
RUN cd neovim && git checkout ${VERSION} && make CMAKE_BUILD_TYPE=RelWithDebInfo install

# To support kickstart.nvim
RUN apk --no-cache add \
  fd  \
  ctags \
  ripgrep \
  git

ENV work_dir="/workspace"
ENV modern_neovim="$work_dir/modern-neovim"

WORKDIR $work_dir

COPY . ./

RUN mkdir -p "$modern_neovim/nvim"
RUN cd $work_dir && stow --restow --target="$modern_neovim/nvim" .


RUN mkdir -p "$modern_neovim/share"

ENV XDG_DATA_HOME="$modern_neovim/share"
ENV XDG_CACHE_HOME="$modern_neovim"
ENV XDG_CONFIG_HOME="$modern_neovim" 

EXPOSE 6666
CMD [ "nvim", "--headless", "--listen",  "0.0.0.0:6666" ]
