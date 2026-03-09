# My Dotfiles

[Chris Oliver's](https://twitter.com/excid3) dotfiles.

Copy these into your terminal and you'll be off to the races.

## Installation

* Clone this repo

```bash
mkdir -p ~/code && cd ~/code && git clone https://github.com/excid3/dotfiles.git
```

* Install Homebrew and packages like Neovim, Mise, etc

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew bundle
```

* Install Oh-My-ZSH

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

* Symlink configs

```bash
ln -s ~/code/dotfiles/zsh/themes/excid3.zsh-theme ~/.oh-my-zsh/themes/excid3.zsh-theme
ln -s ~/code/dotfiles/zsh/zshrc ~/.zshrc
ln -s ~/code/dotfiles/vim/vimrc ~/.vimrc
ln -s ~/code/dotfiles/psqlrc ~/.psqlrc
ln -s ~/code/dotfiles/gemrc ~/.gemrc

mkdir -p ~/.config/nvim
ln -s ~/code/dotfiles/vim/vimrc ~/.config/nvim/init.vim

# Install Vim plugins
vim +PlugInstall +qall
```

* Open iTerm and import color scheme from iterm folder

* Configure git to use [delta](https://github.com/dandavison/delta) and add lg alias

```bash
git config --global color.ui true
git config --global core.pager delta
git config --global interactive.diffFilter 'delta --color-only'
git config --global delta.navigate true
git config --global delta.dark true  # or `delta.light true`, or omit for auto-detection
git config --global merge.conflictStyle zdiff3

# git lg alias
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
```

# Other tips

#### Import GPG Keys

Import your GPG keys using https://www.phildev.net/pgp/gpg_moving_keys.html

Then sign all commits with the key:

  git config --global commit.gpgsign true
