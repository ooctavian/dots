# # ~/.bashrc
#
# fancy prompt
#PS1="\[\e[38;5;30m\]\w\[\e[38;5;35m\] | \[$(tput sgr0)\]"
export PS1="\e[0;34m\w\e[m\e[0;35m >> \e[m"
export SUDO_PROMPT=$'\e[37mpass for \e[0m%u '
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ..='cd ..'
