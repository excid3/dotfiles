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

On macOS this installs Homebrew (only for postgres, redis, and the casks in the
Brewfile); on Debian/Ubuntu it uses apt for zsh, postgres, redis, and the Ruby
build dependencies. It then installs Oh-My-ZSH, symlinks the zsh/bash/psql/gem/nvim/ghostty configs into
place (existing files are backed up to `*.backup`), seeds the openlogi and mise
configs, installs the mise tools from `mise/config.toml` (node, ruby, neovim,
tree-sitter, delta, overmind, tmux, gh, jq), and configures git to use [delta](https://github.com/dandavison/delta) with the
`git lg` alias. It's safe to re-run.

* macOS: open iTerm and import `iterm/Profile.json` (or just the `iterm/Monokai Pro Spectrum.itermcolors` color preset)

## Updating packages

Upgrades mise itself, the mise tools, and the Homebrew packages:

```bash
mise run update
```

# Other tips

#### Import GPG Keys

Import your GPG keys using https://www.phildev.net/pgp/gpg_moving_keys.html

Then sign all commits with the key:

  git config --global commit.gpgsign true
