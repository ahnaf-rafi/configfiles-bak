;;; init.el --- -*- lexical-binding: t; -*-

;;; Code:

;; Name and email.
(setq user-full-name "Ahnaf Rafi")
(setq user-mail-address "ahnaf.al.rafi@gmail.com")

;; Set file for custom.el to use --- I use this for temporary customizations.
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; Load the custom file.
(load custom-file 'noerror 'nomessage)

;; Add user lisp directory to load path.
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install use-package if not present.
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(setq use-package-always-defer t)

(require 'use-package)

(use-package gcmh
  :init
  (setq gcmh-idle-delay 5)
  (setq gcmh-high-cons-threshold (* 100 1024 1024))
  (setq gcmh-verbose init-file-debug)
  (gcmh-mode 1))

(use-package exec-path-from-shell
  :init
  (when (daemonp)
    (exec-path-from-shell-initialize)))

(add-to-list 'default-frame-alist '(font . "JuliaMono-14.0"))
(set-face-attribute 'default nil :font "JuliaMono-14.0")

(use-package nerd-icons)

;; Dealing with Xressources - i.e. don't bother, ignore.
(setq inhibit-x-resources t)

;; Cursor, tooltip and dialog box
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))
(setq visible-cursor nil)
(setq use-dialog-box nil)
(setq x-gtk-use-system-tooltips nil)
(when (fboundp 'tooltip-mode)
  (tooltip-mode -1))

(setq display-line-numbers-type 'visual)
(dolist (hook '(prog-mode-hook text-mode-hook))
  (add-hook hook #'display-line-numbers-mode)
  (add-hook hook #'display-fill-column-indicator-mode))

(defvar aar/use-dark-theme nil
  "Use dark theme if `t' otherwise, use light theme")

(setq modus-themes-org-blocks 'gray-background)

(if aar/use-dark-theme
    (load-theme 'modus-vivendi t)
  (load-theme 'modus-operandi t))

(use-package hl-todo
  :init
  (dolist (hook '(prog-mode-hook tex-mode-hook markdown-mode-hook))
    (add-hook hook #'hl-todo-mode))

  ;; Stolen from doom-emacs: modules/ui/hl-todo/config.el
  (setq hl-todo-highlight-punctuation ":")
  (setq hl-todo-keyword-faces
        '(;; For reminders to change or add something at a later date.
          ("TODO" warning bold)
          ;; For code (or code paths) that are broken, unimplemented, or slow,
          ;; and may become bigger problems later.
          ("FIXME" error bold)
          ;; For code that needs to be revisited later, either to upstream it,
          ;; improve it, or address non-critical issues.
          ("REVIEW" font-lock-keyword-face bold)
          ;; For code smells where questionable practices are used
          ;; intentionally, and/or is likely to break in a future update.
          ("HACK" font-lock-constant-face bold)
          ;; For sections of code that just gotta go, and will be gone soon.
          ;; Specifically, this means the code is deprecated, not necessarily
          ;; the feature it enables.
          ("DEPRECATED" font-lock-doc-face bold)
          ;; Extra keywords commonly found in the wild, whose meaning may vary
          ;; from project to project.
          ("NOTE" success bold)
          ("BUG" error bold)
          ("XXX" font-lock-constant-face bold))))

(use-package which-key
  :demand t
  :init
  (setq which-key-idle-delay 0.3)
  (setq which-key-allow-evil-operators t)
  (which-key-setup-minibuffer)
  (which-key-mode))

(use-package evil
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-u-delete t)
  (setq evil-want-C-i-jump nil)
  (setq evil-want-visual-char-semi-exclusive t)
  (setq evil-ex-search-vim-style-regexp t)
  (setq evil-ex-visual-char-range t)
  (setq evil-respect-visual-line-mode t)
  (setq evil-mode-line-format 'nil)
  (setq evil-symbol-word-search t)
  (setq evil-ex-interactive-search-highlight 'selected-window)
  (setq evil-kbd-macro-suppress-motion-error t)
  (setq evil-split-window-below t)
  (setq evil-vsplit-window-right t)
  (setq evil-flash-timer nil)
  (setq evil-complete-all-buffers nil)
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal))

(use-package evil-collection
  :demand t
  :init
  (setq evil-collection-outline-bind-tab-p nil)
  (setq evil-collection-want-unimpaired-p nil)

  ;; I like to tweak bindings after loading pdf-tools
  (require 'evil-collection)
  (delete '(pdf pdf-view) evil-collection-mode-list)
  (evil-collection-init))

(use-package evil-escape
  :demand t
  :init
  (evil-escape-mode))

(use-package general
  :demand t
  :init
  (general-evil-setup)

  (general-create-definer aar/leader
    :keymaps 'override
    :states '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (general-create-definer aar/localleader
    :keymaps 'override
    :states '(normal insert visual emacs)
    :prefix "SPC m"
    :global-prefix "C-SPC m")

  (aar/localleader
   "" '(nil :which-key "<localleader>"))

  ;; Some basic <leader> keybindings
  (aar/leader
    ":" #'pp-eval-expression
    ";" #'execute-extended-command
    "&" #'async-shell-command
    "u" #'universal-argument))

(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'option))

;; Keybinding definitions
;; Better escape
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;; Text scale and zoom
(global-set-key (kbd "C-+") #'text-scale-increase)
(global-set-key (kbd "C-_") #'text-scale-decrease)
(global-set-key (kbd "C-)") #'text-scale-adjust)

;; Universal arguments with evil
(global-set-key (kbd "C-M-u") 'universal-argument)

;; Visual indent/dedent
;;;###autoload
(defun aar/evil-visual-dedent ()
  "Equivalent to vnoremap < <gv."
  (interactive)
  (evil-shift-left (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

;;;###autoload
(defun aar/evil-visual-indent ()
  "Equivalent to vnoremap > >gv."
  (interactive)
  (evil-shift-right (region-beginning) (region-end))
  (evil-normal-state)
  (evil-visual-restore))

(evil-define-key 'visual 'global
  (kbd "<") #'aar/evil-visual-dedent
  (kbd ">") #'aar/evil-visual-indent)

;; Jumping to function and method definitions
;;;###autoload
(defun aar/next-beginning-of-method (count)
  "Jump to the beginning of the COUNT-th method/function after point."
  (interactive "p")
  (beginning-of-defun (- count)))

;;;###autoload
(defun aar/previous-beginning-of-method (count)
  "Jump to the beginning of the COUNT-th method/function before point."
  (interactive "p")
  (beginning-of-defun count))

(defalias #'aar/next-end-of-method #'end-of-defun
  "Jump to the end of the COUNT-th method/function after point.")

;;;###autoload
(defun aar/previous-end-of-method (count)
  "Jump to the end of the COUNT-th method/function before point."
  (interactive "p")
  (end-of-defun (- count)))

(evil-define-key '(normal visual motion) 'global
  (kbd "] m") #'aar/next-beginning-of-method
  (kbd "[ m") #'aar/previous-beginning-of-method
  (kbd "] M") #'aar/next-end-of-method
  (kbd "[ M") #'aar/previous-end-of-method)

(use-package pdf-tools
  :hook
  (pdf-tools-enabled . aar/pdf-h)
  :init
  (if (eq system-type 'darwin)
      (progn
        (setq pdf-view-use-scaling t)
        (setq pdf-view-use-imagemagick nil)))

  ;; (pdf-loader-install)
  :config
  (evil-collection-pdf-setup)

  (evil-collection-define-key '(normal visual motion) 'pdf-view-mode-map
    (kbd "H")   #'image-bob
    (kbd "J")   #'pdf-view-next-page-command
    (kbd "K")   #'pdf-view-previous-page-command
    (kbd "a")   #'pdf-view-fit-height-to-window
    (kbd "s")   #'pdf-view-fit-width-to-window
    (kbd "L")   #'image-eob
    (kbd "o")   #'pdf-outline
    (kbd "TAB") #'pdf-outline)

  ;; Changes to the usual doom-modeline
  (doom-modeline-def-modeline 'pdf
    '(modals bar window-number matches pdf-pages buffer-info)
    '(misc-info major-mode process vcs))
  )

;;;###autoload
(defun aar/pdf-h ()
  (display-line-numbers-mode 0)
  (turn-off-evil-snipe-mode)
  (setq-local evil-normal-state-cursor (list nil))
  (setq-local mac-mouse-wheel-smooth-scroll nil))

(setq tex-fontify-script nil)

(provide 'init)
;;; init.el ends here
