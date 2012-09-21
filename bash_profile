# .bash_profile

echo -e '\033[1;37m'
fortune -n 500 -s
echo -e '\033[0m'

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PLAN9=/usr/local/plan9
PATH=$PATH:$HOME/bin:$HOME/Code/ducttape:$PLAN9/bin

# eval `ssh-agent`

export PLAN9 PATH
