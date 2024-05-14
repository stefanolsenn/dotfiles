#!/bin/bash -e

current_dir=$(pwd)
dotfiles_dir="$HOME/.dotfiles"
dotfiles_dir_backups="$HOME/.dotfiles-backups"

function dotfiles {
   /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
function remove_tracked_files() {
	if [[ -d $dotfiles_dir ]]; then
		cd $dotfiles_dir
		tracked_files=$(git ls-files)

		for file in $tracked_files;
		do
			rm -f $file
		done

		rm -rf $dotfiles_dir
		rm -rf $dotfiles_dir_backups
		cd $current_dir
	fi
}

remove_tracked_files
git clone --bare git@github.com:stefanolsenn/dotfiles.git "$HOME/.dotfiles"
mkdir -p $dotfiles_dir_backups

if dotfiles checkout -q &>/dev/null; then
    echo "Checked out dotfiles."
    echo "OK!"
else
    echo "Backing up pre-existing dot files."

    dotfiles checkout 2>&1 | grep "^\s+" | awk '{print $1}' | xargs -I{} mv {} "$dotfiles_dir_backups/{}"

    if [ $? -ne 0 ]; then
        echo "Failed to backup dotfiles."
        exit 1
    fi

    dotfiles checkout
    dotfiles config status.showUntrackedFiles no
    source "$HOME/.bashrc"
    echo "OK!"
fi

