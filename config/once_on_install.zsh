#!/usr/bin/env zsh

hash git &>/dev/null && git config --global core.excludesfile $SCRIPT_DIR/config/gitignore_global
hash git &>/dev/null && hash nvim &>/dev/null && git config --global core.editor nvim

function SuggestBinary() {
    command -v $1 --help &>/dev/null || echo "WARN: $1 is missing from the system, you should install it for better bashrc integration"
}

SuggestBinary "colordiff"
SuggestBinary "ack"
SuggestBinary "nvim"
SuggestBinary "astyle"
