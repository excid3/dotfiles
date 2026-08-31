# My Dotfiles

[Chris Oliver's](https://twitter.com/excid3) dotfiles.

Copy these into your terminal and you'll be off to the races.

## Installation

* Clone this repo

```bash
mkdir -p ~/code && cd ~/code && git clone https://github.com/excid3/dotfiles.git
```

* Install [mise](https://mise.jdx.dev)

```bash
curl https://mise.run | sh
```

* Run the bootstrap task

```bash
cd ~/code/dotfiles
mise trust
mise run bootstrap
```

This installs Homebrew and the Brewfile packages, installs Oh-My-ZSH, symlinks
the zsh/psql/gem/nvim configs into place (existing files are backed up to
`*.backup`), seeds the openlogi and mise configs, installs mise tools, and
configures git to use [delta](https://github.com/dandavison/delta) with the
`git lg` alias. It's safe to re-run.

* Open iTerm and import color scheme from iterm folder

## Updating packages

```bash
mise run update
```

# Other tips

#### Import GPG Keys

Import your GPG keys using https://www.phildev.net/pgp/gpg_moving_keys.html

Then sign all commits with the key:

  git config --global commit.gpgsign true
