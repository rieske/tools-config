#!/bin/bash

mkdir -p ~/.config
rm -rf ~/.config/nvim
ln -s ${PWD}/nvim ~/.config/nvim
