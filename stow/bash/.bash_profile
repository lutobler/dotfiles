#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

PATH=$PATH:$HOME/scripts
PATH=$PATH:$HOME/git/hlwm-projects
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH=$PATH:/opt/MATLAB/R2017b/bin
# export PATH=$PATH:/opt/jython/bin

source $HOME/scripts/gnome_keyring_start.sh

export HISTSIZE=
#export EDITOR=$HOME/scripts/txt-open.sh
export EDITOR=nvim
export VISUAL=nvim
export XKB_DEFAULT_LAYOUT=ch
export XKB_DEFAULT_OPTIONS='caps:swapescape'
export WLC_REPEAT_DELAY=200
export WLC_REPEAT_RATE=30
# export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'

export PATH="$PATH:$HOME/go/bin"

