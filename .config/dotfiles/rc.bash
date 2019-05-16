alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
	unalias __git_ps1 2>/dev/null
	. /usr/share/git-core/contrib/completion/git-prompt.sh
else
	alias __git_ps1='echo -n >/dev/null'
fi

PS1='[\u@\h $($HOME/.config/dotfiles/shrinkpath "\w")$(__git_ps1 " (%s)")]$ '
