export PATH=$HOME/Android/Sdk/platform-tools:$PATH
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/bin

source ~/.fzf.zsh
export ZSH="/usr/share/oh-my-zsh"

ZSH_THEME="lukerandall"

plugins=( git pass )

source $ZSH/oh-my-zsh.sh

export NDK=$HOME/Android/Sdk/ndk-bundle
export EDITOR='nvim'

export SSH_KEY_PATH="~/.ssh/rsa_id"
setopt noequals

alias watchcc='sudo watch -c -n1 genlop -c'
alias r=ranger
alias vim=nvim
alias suspend='systemctl suspend'
alias reboot='systemctl reboot'
alias poweroff='systemctl poweroff'
alias hc=herbstclient
alias ve='source venv/bin/activate'

alias uworld='sudo emerge --ask --verbose --update --deep --newuse @world'
alias utime='emerge --pretend --update --deep --newuse @world | sudo genlop -pq'

m() {
    if [[ -f 'Makefile' ]]; then
        make -j5
    else
        for f in *.cpp; do
            base=${f%.*}
            g++ -Wall -Wextra -Wpedantic -ggdb3 -O2 $f -o $base
        done
    fi
}

tortuga() { pirate-get -C 'peerflix "%s" -kdnt -f /var/tmp' "$@"; }
pf() { peerflix "$@" -kdnt --path /var/tmp; }

