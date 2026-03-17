export HISTFILE=/commandhistory/.shell_history
export HISTSIZE=10000
export HISTFILESIZE=10000
shopt -s histappend

parse_git_branch() { git branch 2>/dev/null | grep "^*" | sed "s/* / (/;s/$/)/" ; }
export PS1="\[\033[32m\]\u\[\033[0m\]:\[\033[34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[0m\] \$ "

[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash
[ -f /usr/share/fzf/completion.bash ] && source /usr/share/fzf/completion.bash

alias cl="claude --dangerously-skip-permissions"
