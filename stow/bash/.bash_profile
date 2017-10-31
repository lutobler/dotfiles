#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

PATH=$PATH:$HOME/scripts
export PATH="$(ruby -e 'print Gem.user_dir')/bin:$PATH"
export PATH=$PATH:/opt/MATLAB/R2017b/bin
export PATH=$PATH:/opt/jython/bin

source $HOME/scripts/gnome_keyring_start.sh

export HISTSIZE=
export EDITOR=vis
export VISUAL=vis
export XKB_DEFAULT_LAYOUT=ch
export XKB_DEFAULT_OPTIONS='caps:swapescape'
export WLC_REPEAT_DELAY=200
export WLC_REPEAT_RATE=30
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd'
