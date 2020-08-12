# # ~/.bashrc
#
# fancy prompt
#PS1="\[\e[38;5;30m\]\w\[\e[38;5;35m\] | \[$(tput sgr0)\]"
export PS1="\e[0;34m\w\e[m\e[0;35m >> \e[m"
export SUDO_PROMPT=$'\e[0;31mGimme\e[m \e[1;34myour\e[m \e[1;35mpassword\e[m \e[0;35mmotherfucker: \e[m'
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls -a --color=auto'
alias ..='cd ..'
alias search="xbps-query -Rs"
alias install="sudo xbps-install -S"

export GREP_OPTIONS="--color=auto"; # make grep colorful
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD; # make ls more colorful as well
export HISTSIZE=32768; 
export HISTFILESIZE=$HISTSIZE;
export HISTCONTROL=ignoredups;
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"; # Make some commands not show up in history
export LANG="en_US.UTF-8"; # Language formatting is still important
export LC_ALL="en_US.UTF-8"; # byte-wise sorting and force language for those pesky apps
export MANPAGER="less -X"; # Less is more
bind 'set show-all-if-ambiguous on'
bind 'TAB:menu-complete'
