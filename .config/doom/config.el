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
(setq doom-theme 'doom-opera)
;; (setq doom-theme 'modus-operandi-deuteranopia)
;; (setq doom-theme 'doom-monokai-ristretto)
;; (setq doom-gruvbox-material-background  "medium"
;;       doom-gruvbox-material-palette     "material")

;; (setq doom-gruvbox-material-light-background  "medium"
;;       doom-gruvbox-material-light-palette     "original")

;; (setq doom-theme 'doom-gruvbox)

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

;; `SPC c j' (consult-eglot-symbols) starts with a `#' because consult's default
;; async pipeline uses the "perl" split style (#query#filter). Use the "comma"
;; style instead: nothing is inserted into an empty prompt, but `Query,filter'
;; still splits, which matters because basedpyright matches the whole query as a
;; fuzzy subsequence against the symbol name only -- a space in it returns zero
;; results. Narrowing (`< c' Class, `< f' Function, `< ?' for the list) is
;; independent of the input and works either way.
(defun +consult-async-wrap-no-split (async)
  "Like `consult--async-wrap', but without the `#' input splitter."
  (consult--async-pipeline
   (consult--async-split 'comma)
   async
   (consult--async-indicator)
   (consult--async-refresh)))

(after! consult
  (consult-customize
   consult-eglot-symbols
   :async-wrap #'+consult-async-wrap-no-split))

;; Eglot never sends basedpyright any configuration, so it runs on its own
;; `recommended' default, its loudest preset short of `all'. Note eglot matches a
;; server's requested section against the *top-level* keys of this plist by exact
;; string, so the key must literally be `basedpyright.analysis', not a nested
;; `:analysis'. Projects that ship their own [tool.basedpyright] win over this:
;; basedpyright skips client config overrides when a config file exists and the
;; request came from a language server.
(defun +python--interpreter ()
  "Return the project's Python interpreter.
Eglot calls its workspace-configuration function with `default-directory'
bound to the server's project root, so `.venv' resolves against it."
  (cl-loop for path in (list (and (bound-and-true-p pyvenv-virtual-env)
                                  (expand-file-name "bin/python" pyvenv-virtual-env))
                             (expand-file-name ".venv/bin/python" default-directory))
           when (and path (file-executable-p path))
           return path
           finally return (executable-find "python3")))

(defun +python-eglot-workspace-configuration (_server)
  "Workspace configuration sent to basedpyright."
  ;; No :diagnosticMode "workspace" -- unlike typeCheckingMode it applies even
  ;; when the project has a config file, and on a repo of a few thousand files it
  ;; makes basedpyright type-check everything up front and stop answering
  ;; requests until it is done.
  (list :python (list :pythonPath (+python--interpreter))
        :basedpyright.analysis (list :typeCheckingMode "standard")))

(after! eglot
  (setq-default eglot-workspace-configuration
                #'+python-eglot-workspace-configuration))

;; consult-eglot fires a fresh `workspace/symbol' per keystroke through
;; `jsonrpc-async-request' with no :timeout, so it inherits
;; `jsonrpc-default-request-timeout' (10s) and its :timeout-fn prints "error:
;; request timed out". It never cancels the previous request either, so a
;; 12-character query queues a dozen of them at a single-threaded server. On the
;; basedpyright side each one walks every user source file and parses it on
;; demand, so the cost is O(project) per request -- ~3400 files on broniturov.
;; Give the request room, and type a little longer before firing one. Both must
;; be dynamically bound around the command: consult-eglot builds its async
;; pipeline (and reads the debounce) when it runs, and jsonrpc reads the timeout
;; when it arms the timer.
(defadvice! +consult-eglot-patient-a (fn &rest args)
  "Run FN with timeouts sized for a large workspace."
  :around #'consult-eglot-symbols
  (let ((jsonrpc-default-request-timeout 60)
        (consult-async-input-debounce 0.4)
        (consult-async-input-throttle 0.5))
    (apply fn args)))
