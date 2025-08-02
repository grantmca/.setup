#!/usr/bin/env bash

include_profile base

manage_package zsh
manage_package neovim nvim
manage_package ripgrep rg
manage_package bat batcat
manage_package ghostty

create_layer nvim
create_layer ghostty
