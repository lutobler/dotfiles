# If not running interactively, don't do anything
[[ $- != *i* ]] && return

trysource() { [[ -f "$1" ]] && source "$1"; }

# trysource ~/bash.d/init-prompt
trysource ~/bash.d/functions
trysource ~/bash.d/aliases
trysource ~/.fzf.bash
[[ "$TERM" == rxvt-unicode-256color ]] && trysource ~/bash.d/ps1-powerline
