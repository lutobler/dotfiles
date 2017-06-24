# If not running interactively, don't do anything
[[ $- != *i* ]] && return

trysource() { [[ -f "$1" ]] && source "$1"; }

trysource ~/.fzf.bash
trysource ~/bash.d/functions
trysource ~/bash.d/aliases
[[ "$TERM" == rxvt-unicode-256color ]] && trysource ~/bash.d/ps1-powerline

export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
