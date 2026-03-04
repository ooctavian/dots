HISTFILE=~/.history
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history

bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward

alias v='nvim'
alias o='xdg-open'
alias g='git'

alias ls='ls --color=auto -hv'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -c=auto'

alias l='ls'
alias ll='ls -l'
alias la='ls -lA'

alias mv='mv -i'

autoload -U compinit && compinit

precmd () { print -Pn "\e]2;%-3~\a"; }

PS1='%F{blue}%B%~%b%f %F{green}❯%f '

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=white'
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function cd() {
  builtin cd "$@"

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    ## If env folder is found then activate the vitualenv
      if [[ -d ./.venv ]] ; then
        source ./.venv/bin/activate
      fi
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate
      parentdir="$(dirname "$VIRTUAL_ENV")"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        deactivate
      fi
  fi
}

tmux-git-autofetch() {(/home/octavian/.tmux/plugins/tmux-git-autofetch/git-autofetch.tmux --current &)}
add-zsh-hook chpwd tmux-git-autofetch
    
