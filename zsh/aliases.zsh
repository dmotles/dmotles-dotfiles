#!/bin/zsh

OS=$(uname -s)

case $OS in
    Darwin)
        alias ls='ls -G'
        ;;
esac
