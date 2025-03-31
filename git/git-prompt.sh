# options
PROMPT_DIRTRIM=1

# color codes
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
BRIGHT_GREEN="\[\033[1;32m\]"
CYAN="\[\033[0;36m\]"
BRIGHT_CYAN="\[\033[1;36m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
PURPLE="\[\033[0;35m\]"
WHITE="\[\033[0;37m\]"
PINK="\[\033[1;31m\]"
BOLD="\[\e[1m\]"
RESET="\[\033[0m\]"

# git completion
if test -z "$WINELOADERNOEXEC"
then
    GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
    COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
    COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
    COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
    if test -f "$COMPLETION_PATH/git-prompt.sh"
    then
        . "$COMPLETION_PATH/git-completion.bash"
        . "$COMPLETION_PATH/git-prompt.sh"
    fi
fi

# kubectl completion
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

# prompt
DECORATE=0
if [ "$DECORATE" -eq 1 ]; then
    GIT_PS1_SHOWCOLORHINTS=true
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    export PS1="${BRIGHT_GREEN}${BOLD}➜  ${BRIGHT_CYAN}\W\$(__git_ps1 ' (%s)')${RESET} "
else
    export PS1="${BRIGHT_GREEN}${BOLD}➜  ${BRIGHT_CYAN}\W${RESET} "
fi

# aliases
alias ls='ls -F --color=auto --show-control-chars'
alias k='kubectl'

# functions
new_script() {
    if [ -z "$1" ]; then
        echo "Usage: new_script <script_name>"
        return
    fi

    if [ -f $1 ]; then
        echo "File already exists"
        return
    fi

    cat <<EOF > $1
#!/bin/bash

set -e

log () {
    timestamp=\$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo -e "\033[90m\$timestamp\033[0m ➜  \$1"
}

error () {
    timestamp=\$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo -e "\033[90m\$timestamp\033[0m \033[91m✗ \$1\033[0m"
    exit 1
}

prompt () {
    timestamp=\$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo -ne "\033[90m\$timestamp\033[0m \033[93m➜  \$1\033[0m "
}

EOF

    nvim $1
}
