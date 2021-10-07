export EDITOR='nvim'

PS1=${(j::Q)${(Z:Cn:):-$'
    %F{cyan}%f
    %(!.%F{red}%n%f.%F{green}%n%f)
    %F{cyan}@%f
    %F{yellow}%M%f
    %F{cyan}" "[%f
    %F{blue}%~%f
    %F{cyan}]" "%f
    %(!.%F{red}%#%f.%F{green}%#%f)
    " "
    '}}

HISTFILE=~/.history-zsh
export HISTSIZE=10000
export SAVEHIST=10000
setopt append_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
setopt no_beep
setopt auto_cd

autoload -Uz compinit && compinit
setopt complete_in_word
setopt auto_menu
setopt autocd
ZLE_REMOVE_SUFFIX_CHARS=$' \t\n;&'

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "\e[3~" delete-char

man() {
  env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

alias ls='ls --color --group-directories-first -F'
alias watchcc='sudo watch -c -n1 genlop -c'
alias r=ranger
alias vim=nvim
alias suspend='systemctl suspend'
alias reboot='systemctl reboot'
alias poweroff='systemctl poweroff'
alias hc=herbstclient
alias ve='source venv/bin/activate'
alias ault='ssh -J ltobler@ela.cscs.ch ltobler@ault.cscs.ch'
alias ault-copy-pwd='scp -r -J ltobler@ela.cscs.ch $PWD ltobler@ault.cscs.ch:'
alias msc='cd ~/ethz/master/thesis/msc-lutobler-gpuless'
alias make='make -j9'

syncstat() { watch -d grep -e Dirty: -e Writeback: /proc/meminfo; }
tortuga() { pirate-get -C 'peerflix "%s" -kdnt -f /var/tmp' "$@"; }
pf() { peerflix "$@" -kdnt --path /var/tmp; }
