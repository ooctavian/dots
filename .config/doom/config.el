;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "BlexMono Nerd Font" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "BlexMono Nerd Font" :size 15))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-flatwhite)
;; (setq doom-theme 'doom-tomorrow-night)
;; (setq doom-theme 'doom-opera)
;; (setq doom-theme 'modus-operandi-deuteranopia)
;; (setq doom-theme 'doom-monokai-ristretto)
;; (setq doom-gruvbox-material-background  "medium"
;;       doom-gruvbox-material-palette     "material")

;; (setq doom-gruvbox-material-light-background  "medium"
;;       doom-gruvbox-material-light-palette     "original")

(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type `relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
(after! eglot
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode)
                 . ("basedpyright-langserver" "--stdio"))))
(setq shell-file-name (executable-find "fish"))

(defun my-projectile-venv-and-env-activate ()
  "Activate the project's Python virtual environment and load .env-local if present."
  (message "Activating project venv and loading .env-local (if any)...")
  (when (projectile-project-p)
    (let* ((project-root (projectile-project-root))
           (venv-path (expand-file-name ".venv" project-root))
           (env-file (expand-file-name ".env-local" project-root)))
      ;; Activate the virtual environment if it exists
      (when (file-directory-p venv-path)
        (pyvenv-activate venv-path)
        (message "Activated virtual environment: %s" venv-path))
      ;; Load environment variables if .env-local exists
      (when (file-readable-p env-file)
        (load-env-vars env-file)
        (message "Loaded environment variables from: %s" env-file)))))

;; Optionally hook this into Projectile switching or Python mode
(add-hook 'projectile-after-switch-project-hook #'my-projectile-venv-and-env-activate)
;; (add-hook 'python-mode-hook #'my-projectile-venv-and-env-activate)
