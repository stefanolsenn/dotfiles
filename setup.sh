#!/bin/bash

current_dir=$(pwd)
dotfiles_dir="$HOME/.dotfiles"
dotfiles_dir_backups="$HOME/.dotfiles-backups"

function dotfiles() {
	/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}

function exit_if_err() {
	if [[ $? -ne 0 ]]; then
		exit 1
	fi
}

function clone() {
	if [[ -d $dotfiles_dir ]]; then
		rm -rf $dotfiles_dir
	fi
	git clone -q --bare git@github.com:stefanolsenn/dotfiles.git $dotfiles_dir 
	echo "Cloned dotfiles"
} 

function backup_existing_files() {
	mkdir -p $dotfiles_dir_backups 
	cd $dotfiles_dir 
	tracked_files=$(git ls-tree -r master --name-only)

	for file in $tracked_files;
	do
		mv -f $HOME/$file $dotfiles_dir_backups > /dev/null
	done

	cd $current_dir
	echo "Backed up all existing files"
}

clone 
backup_existing_files
dotfiles checkout 
exit_if_err
dotfiles config status.showUntrackedFiles no
source "$HOME/.bashrc"
echo "OK!"

