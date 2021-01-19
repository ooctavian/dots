{ config, pkgs, ... }:
let plugins = pkgs.vimPlugins // pkgs.callPackage ../packages/vimPlugins.nix {};
in
  {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      extraConfig = ( builtins.readFile ./files/init.vim );
      extraPackages = with pkgs;[ 
        fzf
        clang-tools
        lua53Packages.lua-lsp
        rnix-lsp
        haskellPackages.haskell-language-server
        ccls
      ] ;
      plugins = with pkgs.vimPlugins; [
        lightline-vim
        lightline-bufferline
        coc-nvim
        coc-json
        coc-css
        plugins.nord
        vim-smoothie
        vim-nix
        vim-commentary
        plugins.coloresque
        plugins.ayu
      ];
    };
    xdg.configFile."nvim/coc-settings.json".source = ./files/coc-settings.json;
  }
