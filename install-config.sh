#!/bin/bash

rm -f ~/.vimrc
ln -s ${PWD}/vim/.vimrc ~/.vimrc
rm -rf ~/.vim
ln -s ${PWD}/vim/.vim ~/.vim
git clone git@github.com:VundleVim/Vundle.vim.git vim/.vim/bundle/Vundle.vim/

rm -f ~/.tmux.conf
ln -s ${PWD}/tmux/.tmux.conf ~/.tmux.conf
rm -rf ~/.tmux
ln -s ${PWD}/tmux/.tmux ~/.tmux

mkdir -p ~/.config/herdr
rm -f ~/.config/herdr/config.toml
ln -s ${PWD}/herdr/config.toml ~/.config/herdr/config.toml
