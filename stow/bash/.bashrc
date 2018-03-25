# vim: set ft=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

trysource() { [[ -f "$1" ]] && source "$1"; }
pwlterm() {
    [[ "$TERM" == rxvt-unicode-256color ]] || \
    [[ "$TERM" == screen-256color ]] || \
    [[ "$TERM" == xterm-256color ]] || \
    [[ "$TERM" == xterm-termite ]] ||
    return $?
}

# trysource ~/bash.d/init-prompt
trysource ~/bash.d/functions
trysource ~/bash.d/aliases
trysource ~/.fzf.bash
pwlterm && trysource ~/bash.d/ps1-powerline
