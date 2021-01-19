{ config, pkgs, ... }:
{
    programs.firefox = {
    enable = true;
    profiles = {
      myprofile = {
        id = 0;
        settings = {
          "general.smoothScroll" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
         userChrome = ''
      :root {
        --faint-bg: #2e3440;
        --faint-bg-alt: #3b4252;
        --faint-fg: #d8dee9;
        --urlbar-separator-color: taransparent !important;
        --toolbarbutton-border-radius: 0px !important;
      }

      panelview,
      .panel-arrowcontent,
      scrollbox {
        background-color: var(--faint-bg) !important;
        color: var(--faint-fg) !important;
      }

#urlbar-input-container {
        background-color: var(--faint-bg-alt) !important;
        color: var(--faint-fg) !important;
      }

      .chromeclass-toolbar-additional {
        background-color: var(--faint-bg);
        color: var(--faint-fg);
      }

#urlbar,
      .urlbarView-body-inner {
        border: none !important;
      }

#PanelUI-button {
        background-color: var(--faint-bg);
        color: var(--faint-fg);
        border: none !important;
      }

#urlbar-background,
#searchbar {
        background-color: var(--faint-bg-alt) !important;
        color: var(--faint-fg) !important;
        border: none !important;
        box-shadow: none;
      }

#navigator-toolbox {
        border-bottom-width: 0px !important;
      }

      toolbarseparator {
        display: none;
      }

      .tabbrowser-tab {
        border-radius: 0px !important;
      }

      .tabbrowser-tab::after,
      .tabbrowser-tab::before {
        border-left: none !important;
      }

      .tab-line {
        height: 100% !important;
      }

      .tabs-newtab-button:hover,
      .tabbrowser-tab:hover:not([selected]),
      .tabbrowser-tab[selected] {
        color: var(--faint-fg) !important;
        background-color: var(--faint-bg-alt) !important;
         border-radius: 0px;
      }

      .tab-background {
        background: transparent !important;
      }

#library-button {
        background-color: var(--faint-bg);
      }

#nav-bar {
        box-shadow: none !important;
      }

#urlbar-container,
#search-container {
        background-color: var(--faint-bg);
      }

#nav-bar-customization-target {
        background-color: var(--faint-bg);
      }
      :root:not([uidensity='compact']):not([chromehidden~='toolbar'])
        #PanelUI-button {
        margin-inline-start: 0px;
        border-image-slice: none;
      }

      .browser-toolbar {
        color: var(--faint-fg) !important;
      }

      .browser-toolbar:not(.titlebar-color) {
        background-color: var(--faint-bg) !important;
        background-image: none !important;
           }
    '';
};
       };
     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          https-everywhere
          privacy-badger
          vimium
          cookie-autodelete
    ];
     };
}
