# Are any updates needed?
TIME='\[\e[96m\]\@'
WD='\[\e[91m\]\w'
USR='\[\e[31m\]\u'
AT='\[\e[0m\]@'
HOST='\[\e[36m\]\h'
STINGER='\[\e[91m\]-->\[\e[0m\] '

# Install auto completion
source ~/.vim/completion/*

export EDITOR="vim"
export TZ="America/Los_Angeles"
export PS1="${TIME} ${WD}\n${USR}${AT}${HOST}${STINGER}"
export PROMPT_COMMAND=""
export PATH="${PATH}:/usr/local/bin:${HOME}/bin"

if [ -f ~/.bash_vars ]; then
	source ~/.bash_vars
fi

if [ -f ~/.vim/bofh_enable ]; then
	timeout 2 curl -s https://raw.githubusercontent.com/elstevi/shitism-server/master/bofh.txt | sort -R | head -n1 2> /dev/null
fi

