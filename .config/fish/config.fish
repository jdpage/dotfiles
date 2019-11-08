# Helper for working with dotfile version control
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Set default umask
umask 0002

# Local paths
set -x PATH $PATH "$HOME/.local/bin" "$HOME/bin"

# System paths that fedora sets from /etc/profile
set -x PATH $PATH "/usr/local/sbin" "/usr/sbin"

# pyenv stuff
if test -d "$HOME/.pyenv/bin"
    set -x PATH "$HOME/.pyenv/bin" $PATH
    pyenv init - | source
end

# poetry stuff
if test -d "$HOME/.poetry/bin"
    set -x PATH "$HOME/.poetry/bin" $PATH
end

# opam configuration
source /home/jdpage/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# go stuff
if type -q go
    set -x GOPATH "$HOME/go"
    set -x PATH "$GOPATH/bin" $PATH
end

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate 'ε'
set __fish_git_prompt_char_stagedstate 'δ'
set __fish_git_prompt_char_untrackedfiles '?'
set __fish_git_prompt_char_stashstate 'z'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

function fish_prompt --description 'Write out the prompt'
    printf '%s@%s %s%s%s%s> ' \
    $USER (prompt_hostname) \
    (set_color $fish_color_cwd) (prompt_pwd) (set_color normal) \
    (__fish_git_prompt)
end

function fish_greeting
    if type -q fortune
        if type -q cowsay
            fortune -n 500 -s -a | cowsay -W 72
        else
            fortune -n 500
        end
    end
end
