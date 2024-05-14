#!/bin/bash -e

if [ -d "$HOME/.dotfiles" ]; then
    rm -rf "$HOME/.dotfiles"
fi

git clone --bare git@github.com:stefanolsenn/dotfiles.git "$HOME/.dotfiles"
mkdir -p "$HOME/.dotfiles-backups"

if dotfiles checkout -q &>/dev/null; then
    echo "Checked out dotfiles."
    echo "OK!"
else
    echo "Backing up pre-existing dot files."

    dotfiles checkout 2>&1 | grep "^\s+" | awk '{print $1}' | xargs -I{} mv {} "$HOME/.dotfiles-backups/{}"

    if [ $? -ne 0 ]; then
        echo "Failed to backup dotfiles."
        exit 1
    fi

    dotfiles checkout
    dotfiles config status.showUntrackedFiles no
    source "$HOME/.bashrc"
    echo "OK!"
fi

