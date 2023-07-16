PROMPT_DIRTRIM=3                # shorten deep paths in the prompt
PS1='\[\033]0;\W\007\]'         # set window title
PS1="$PS1"'\n'                  # new line
PS1="$PS1"'\[\033[30;46m\] \w ' # working directory

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

PS1="$PS1"'\[\033[0m\]'         # reset color
PS1="$PS1"'\n'                  # new line
PS1="$PS1"'$ '                  # prompt: always $

# aliases
alias ls='ls -F --color=auto --show-control-chars'
