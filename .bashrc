TIME='\[\e[96m\]\@'
WD='\[\e[91m\]\w'
USR='\[\e[31m\]\u'
AT='\[\e[0m\]@'
HOST='\[\e[36m\]\h'
STINGER='\[\e[91m\]-->\[\e[0m\] '

# Install auto completion
if [ -d "$HOME/.vim/completion" ]; then
    for file in "$HOME/.vim/completion"/*; do
        [ -e "$file" ] && source "$file"
    done
fi

if [ -f ~/.bash_vars ]; then
	source ~/.bash_vars
fi

export EDITOR="vim"
export PAGER="less"
export TZ="America/Los_Angeles"
export PS1="${TIME} ${WD}\n${USR}${AT}${HOST}${STINGER}"
export PROMPT_COMMAND=""
export PATH="${PATH}:/usr/local/bin:${HOME}/bin"

if [ -f ~/.vim/bofh_enable ]; then
	timeout 2 curl -s https://raw.githubusercontent.com/elstevi/shitism-server/master/bofh.txt | sort -R | head -n1 2> /dev/null
fi

if [ "$(uname)" == "Darwin" ]; then
	export HOMEBREW_PREFIX="/opt/homebrew";
	export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
	export HOMEBREW_REPOSITORY="/opt/homebrew";
	fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
	PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin"; export PATH;
	[ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
	export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
	export BASH_SILENCE_DEPRECATION_WARNING=1
fi

if [ "$(which pyenv)" ]; then
	eval "$(pyenv virtualenv-init -)"
fi

# Auto update logic for yadm
yaup() {
	yadm pull -f origin master
	yadm bootstrap
}

if [[ "$(which yadm)" && ! -f ".yadm_no_autoupdate" && $- == *i* ]]; then
	OUTPUT="$(timeout 4 yadm remote show origin)"
	if ! echo "${OUTPUT}" | grep 'up to date' > /dev/null; then
		yadm fetch origin
		dialog --title "yadm update" --yesno "$(git log $(git branch --show-current) origin/master)" 6 20
		if [ $? -eq 0 ]; then
			yaup
		else
			echo "not doing anything"
		fi
	fi
fi


# https://boreal.social/post/15-practical-bash-functions-i-use-in-my-bashrc
# saw these on reddit, seemed useful
mkcd() {
    mkdir -p "$1" && cd "$1"
}

hist() {
    history | grep -i "$1"
}

ff() {
    find . -type f -iname "*$1*" 2>/dev/null
}
# ff .pdf    → finds all PDFs anywhere below current dir

fd() {
    find . -type d -iname "*$1*" 2>/dev/null
}

serve() {
    local port=${1:-8000}
    echo "Serving on http://localhost:$port"
    python3 -m http.server "$port"
}

colors() {
    for i in {0..255}; do
        printf '\e[48;5;%dm%3d ' "$i" "$i"
        (((i+3) % 18)) || printf '\e[0m\n'
    done
    printf '\e[0m\n'
}

path() {
    echo "$PATH" | tr ":" "\n"
}

mans() {
    man "$1" | grep -iC 5 "$2"
}
# Usage: mans tar extract  -> Shows 'tar' man page entries near 'extract'

trash() {
    mkdir -p ~/.local/share/Trash/files
    mv "$@" ~/.local/share/Trash/files/
    echo "Moved to ~/.local/share/Trash/files/"
}

ports() {
    lsof -iTCP -sTCP:LISTEN -P -n
}

git-undo() {
    git reset --soft HEAD~1
}

extract-ip() {
    grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" "$1" | sort -u
}
# Usage: extract-ip access.log

top-size() {
    du -hs * | sort -rh | head -10
}
