# Helper for working with dotfile version control
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Local paths
set -x PATH $PATH "$HOME/.local/bin" "$HOME/bin"

# pyenv stuff
set -x PATH "$HOME/.pyenv/bin" $PATH
pyenv init - | source

# poetry stuff
set -x PATH "$HOME/.poetry/bin" $PATH

# opam configuration
source /home/jdpage/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# go stuff
set -x GOPATH "$HOME/go"
set -x PATH "$GOPATH/bin" $PATH
