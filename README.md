# Setup new system

```shell
#!/bin/bash
git clone --bare git@github.com:stefanolsenn/dotfiles.git $HOME/.dotfiles

function dotfiles {
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

mkdir -p $HOME/.dotfiles-backups
dotfiles checkout -q &> /dev/null

if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dot files.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} $HOME/.dotfiles-backups/{}
fi;

dotfiles checkout
dotfiles config status.showUntrackedFiles no

```
