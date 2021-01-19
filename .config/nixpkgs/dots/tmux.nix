{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;

    plugins = with pkgs.tmuxPlugins; [
      sensible  # default settings
      {
        plugin = resurrect; # save: bindkey ctrl+s restore: bindkey ctrl+r
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum; # auto save/restore upon restart
        extraConfig = ''
          set -g @continuum-restore 'on'
          # set -g @continuum-save-interval '60' # minutes
        '';
      }
      open      # open things
      yank      # copy to system clipboard
    ];

    extraConfig = ''
      set-window-option -g automatic-rename on
      # Set default shell
      # set -g default-shell /home/davidmaceachern/.nix-profile/bin/zsh
      set -g default-terminal "screen-256color"
      # Enable mouse mode (tmux 2.1 and above)
      set -g mouse on
      # remap prefix from 'C-b' to 'C-a'
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %
      # Copy and Paste
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
      # bind -t vi-copy y copy-pipe "xclip -sel clip -i" <----- started causing issues loading config

set -sg escape-time 0
set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
set-option -g status-interval 1
set-option -g status-position top
set-option -g window-status-format '#[fg=3,bg=0] #[fg=0,bg=colour3]#I #W#[fg=3,bg=colour0]'
set-option -g window-status-current-format '#[fg=4,bg=0] #[fg=0,bg=colour4]#I #W#[fg=4,bg=colour0]'
set-option -g window-status-separator \'\'
set -g status-right "#[fg=2]  #{pane_current_path}"
set-option -g status-left-length 20
set-option -g status-justify left
    '';
  };
}
