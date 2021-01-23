;;
;;; Initialize package.el
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("elpa" . "https://elpa.gnu.org/packages/"))

(package-initialize)

;; Bootstrap `use-package'
(setq-default use-package-always-ensure t ; Auto-download package if not exists
              use-package-always-defer t ; Always defer load package to speed up startup
              use-package-verbose nil ; Don't report loading details
              use-package-expand-minimally t  ; make the expanded code as minimal as possible
              use-package-enable-imenu-support t) ; Let imenu finds use-package definitions

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;
;;; A quieter startup

;; Display the bare minimum at startup. We don't need all that noise. The
;; dashboard/empty scratch buffer is good enough.
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

;;
;;; Don't litter `my-emacs-dir'

(use-package no-littering
  :demand
  :config
  ; Exclude no-littering files from recentf.
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  ; If auto-save file has to be stored, it goes to var directory.
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  ; Don't save customizations to init.el!
  (setq custom-file (no-littering-expand-etc-file-name "custom.el")))

;;
;;; Optimizations

(use-package gcmh
  :hook
  (after-init-hook . gcmh-mode)
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024))
  :config (gcmh-mode 1))

;;
;;; Evil Stuff

(use-package evil
  :demand
  :init
  (setq evil-want-C-i-jump (or (daemonp) (display-graphic-p))
        evil-want-C-u-scroll t
        evil-want-C-u-delete t
        evil-want-C-w-scroll t
        evil-want-C-w-delete t
        evil-want-Y-yank-to-eol t
        evil-want-abbrev-expand-on-insert-exit nil
        evil-respect-visual-line-mode t
        evil-want-visual-char-semi-exclusive t
        ;; more vim-like behavior
        evil-symbol-word-search t
        ;; cursor appearance
        evil-normal-state-cursor 'box
        evil-insert-state-cursor 'bar
        evil-visual-state-cursor 'hollow
        ;; undo tool to use
        evil-undo-system 'undo-redo ;; undo-redo as of emacs28
        ;; for evil-collection
        evil-want-integration t ; This is optional since it's already set to t by default.
        evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :demand
  :init
  (setq evil-collection-setup-minibuffer t
        evil-collection-company-use-tng nil
        evil-collection-want-unimpaired-p nil)
  :config
  (evil-collection-init))

;;;
;;;; Keybindings

(defvar my-leader-key "SPC"
  "My evil leader.")

(defvar my-localleader-key "SPC m"
  "The localleader prefix key, for major-mode specific commands.")

;;; General

(use-package general
  :demand t
  :config
  (general-create-definer my-general-leader
    :states 'normal
    :keymaps 'override
    :prefix my-leader-key)
  (general-create-definer my-general-localleader
    :states 'normal
    :keymaps 'override
    :prefix my-localleader-key))

;;; which-key

(use-package which-key
  :hook (pre-command . which-key-mode)
  :init
  (setq which-key-sort-order #'which-key-prefix-then-key-order
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10)
  :config
  (which-key-mode +1))

(my-general-leader
  "w" 'save-buffer
  "q" 'evil-quit)

;;;
;;;; Ivy <3

(use-package ivy
  :demand
  :general
  (my-general-leader
    "b" 'ivy-switch-buffer)
  :init
  :config
  (setq ivy-height 17
        ivy-count-format "%d/%d "
        ivy-more-chars-alist
        '((counsel-rg . 1)
          (counsel-search . 2)
          (t . 3)))

  (ivy-mode +1))

(use-package counsel
  :general
  (general-define-key
   "M-x" 'counsel-M-x)
  (my-general-leader
    "s" 'swiper
    "f" 'counsel-fzf
    "g" 'counsel-git
    "r" 'counsel-rg
    "R" 'counsel-recentf)
  :init
  ;; Use the faster search tool: ripgrep (`rg')
  (when (executable-find "rg")
    (setq counsel-grep-base-command "rg -S --no-heading --line-number --color never %s %s"))
  :config
  (with-no-warnings
    ;; Display an arrow with the selected item
    (defun my-ivy-format-function-arrow (cands)
      "Transform CANDS into a string for minibuffer."
      (ivy--format-function-generic
       (lambda (str)
         (concat (if (and (bound-and-true-p all-the-icons-ivy-rich-mode)
                          (>= (length str) 1)
                          (string= " " (substring str 0 1)))
                     ">"
                   "> ")
                 (ivy--add-face str 'ivy-current-match)))
       (lambda (str)
         (concat (if (and (bound-and-true-p all-the-icons-ivy-rich-mode)
                          (>= (length str) 1)
                          (string= " " (substring str 0 1)))
                     " "
                   "  ")
                 str))
       cands
       "\n"))
    (setf (alist-get 't ivy-format-functions-alist) #'my-ivy-format-function-arrow)

    (setq swiper-action-recenter t)))

;;;
;;;; UI

;;
;;; General UX

(setq uniquify-buffer-name-style 'forward
      ;; no beeping or blinking please
      ring-bell-function #'ignore
      visible-bell nil)

;; Enable mouse in terminal Emacs
(add-hook 'tty-setup-hook #'xterm-mouse-mode)

;;; Scrolling

(setq hscroll-margin 2
      hscroll-step 1
      ;; Emacs spends too much effort recentering the screen if you scroll the
      ;; cursor more than N lines past window edges (where N is the settings of
      ;; `scroll-conservatively'). This is especially slow in larger files
      ;; during large-scale scrolling commands. If kept over 100, the window is
      ;; never automatically recentered.
      scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount '(5 ((shift) . 2))
      mouse-wheel-progressive-speed nil)  ; don't accelerate scrolling

;;; Cursor

;; Don't blink the cursor, it's too distracting.
(blink-cursor-mode -1)

;; Don't blink the paren matching the one at point, it's too distracting.
(setq blink-matching-paren nil)

(setq visible-cursor nil)

;; Don't stretch the cursor to fit wide characters, it is disorienting,
;; especially for tabs.
(setq x-stretch-cursor nil)

;;; Fringes

;; Reduce the clutter in the fringes; we'd like to reserve that space for more
;; useful information, like git-gutter and flycheck.
(setq indicate-buffer-boundaries nil
      indicate-empty-lines nil)

;; remove continuation arrow on right fringe
(setq fringe-indicator-alist
      (delq (funcall 'assq 'continuation fringe-indicator-alist)
            fringe-indicator-alist))

;;; Windows/frames

;; A simple frame title
(setq frame-title-format '("%b – Emacs")
      icon-title-format frame-title-format)

;; always avoid GUI
(setq use-dialog-box nil)

;; Favor vertical splits over horizontal ones. Screens are usually wide.
(setq split-width-threshold 160
      split-height-threshold nil)

;;; Minibuffer

;; Allow for minibuffer-ception. Sometimes we need another minibuffer command
;; while we're in the minibuffer.
(setq enable-recursive-minibuffers t)

;; Show current key-sequence in minibuffer, like vim does. Any feedback after
;; typing is better UX than no feedback at all.
(setq echo-keystrokes 0.02)

;; Expand the minibuffer to fit multi-line text displayed in the echo-area. This
;; doesn't look too great with direnv, however...
(setq resize-mini-windows 'grow-only
      ;; But don't let the minibuffer grow beyond this size
      max-mini-window-height 0.15)

;; Typing yes/no is obnoxious when y/n will do
(advice-add #'yes-or-no-p :override #'y-or-n-p)

;;; Theme & font

;; Underline looks a bit better when drawn lower
(setq x-underline-at-descent-line t)

(set-face-attribute 'default nil :height 105)

;; swap that font
;(add-to-list 'default-frame-alist '(font . "SpaceMono Nerd Font-10"))

;;; Built-in packages

(use-package goto-addr
  :ensure nil
  :hook (text-mode . goto-address-mode)
  :hook (prog-mode . goto-address-prog-mode)
  :config
  (define-key goto-address-highlight-keymap (kbd "RET") #'goto-address-at-point))

(use-package hl-line
  :ensure nil
  ;; Highlights the current line
  :hook ((prog-mode text-mode conf-mode) . hl-line-mode))

(use-package paren
  :ensure nil
  ;; highlight matching delimiters
  :hook ((prog-mode text-mode conf-mode) . show-paren-mode)
  :config
  (setq show-paren-delay 0.1
        show-paren-highlight-openparen t
        show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t)
  (show-paren-mode +1))

;;; Line numbers

;; Explicitly define a width to reduce computation
(setq-default display-line-numbers-width 3)

;; Show absolute line numbers for narrowed regions
(setq-default display-line-numbers-widen t)

;; Make line numbers relative.
(setq-default display-line-numbers-type 'relative)

;; Enable line numbers in most text-editing modes
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'text-mode-hook #'display-line-numbers-mode)
(add-hook 'conf-mode-hook #'display-line-numbers-mode)

(defun my-enable-line-numbers-h ()  (display-line-numbers-mode +1))
(defun my-disable-line-numbers-h () (display-line-numbers-mode -1))

;;; Third-party packages

(use-package all-the-icons
  :commands (all-the-icons-octicon
             all-the-icons-faicon
             all-the-icons-fileicon
             all-the-icons-wicon
             all-the-icons-material
             all-the-icons-alltheicon))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("BUG"        success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

;; Highlight brackets according to their depth
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (sly-mrepl-mode . rainbow-delimiters-mode))
  :init
  ;; Helps us distinguish stacked delimiter pairs, especially in parentheses-drunk
  ;; languages like Lisp.
  (setq rainbow-delimiters-max-face-count 7))

(use-package doom-themes
  :init
  (load-theme 'doom-tomorrow-night t))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (unless after-init-time
    ;; prevent flash of unstyled modeline at startup
    (setq-default mode-line-format nil))
  ;; Set these early so they don't trigger variable watchers
  (setq doom-modeline-bar-width 3
        doom-modeline-buffer-file-name-style 'relative-from-project))

(use-package highlight-indent-guides
  :disabled
  :hook ((prog-mode text-mode conf-mode) . highlight-indent-guides-mode)
  :init
  (setq highlight-indent-guides-method 'character
        highlight-indent-guides-responsive 'stack))

;;;
;;;; Dired

(use-package dired
  :ensure nil
  :commands dired-jump
  :general
  (my-general-leader
   "1" 'dired-jump)
  :init
  (setq dired-auto-revert-buffer t ; don't prompt to revert; just do it
        dired-dwim-target t ; suggest a target for moving/copying intelligently
        dired-hide-details-hide-symlink-targets nil
        ;; Always copy/delete recursively
        dired-recursive-copies 'always
        dired-recursive-deletes 'top
        ;; Screens are larger nowadays, we can afford slightly larger thumbnails
        image-dired-thumb-size 150))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package diff-hl
  :hook (dired-mode . diff-hl-dired-mode-unless-remote) ; FIXME can't use tramp with it
  :hook (magit-pre-refresh . diff-hl-magit-pre-refresh)
  :hook (magit-post-refresh . diff-hl-magit-post-refresh)
  :hook ((prog-mode text-mode conf-mode) . global-diff-hl-mode)
  :config
  (defun +diff-hl-fringe-bmp-fn (_type _pos)
    "Fringe bitmap function for use as `diff-hl-fringe-bmp-function'."
    (define-fringe-bitmap 'my-diff-hl-bmp
      '[252]
      1 8
      '(center t)))
  (setq diff-hl-fringe-bmp-function #'+diff-hl-fringe-bmp-fn)

  (unless (display-graphic-p)
    (setq diff-hl-margin-symbols-alist
          '((insert . " ") (delete . " ") (change . " ")
            (unknown . " ") (ignored . " ")))
    ;; Fall back to the display margin since the fringe is unavailable in tty
    (diff-hl-margin-mode 1)
    ;; Avoid restoring `diff-hl-margin-mode'
    (with-eval-after-load 'desktop
      (add-to-list 'desktop-minor-mode-table
                   '(diff-hl-margin-mode nil))))
  )

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dired-x
  :ensure nil
  :hook (dired-mode . dired-omit-mode)
  :config
  (setq dired-omit-verbose nil
        dired-omit-files
        (concat dired-omit-files
                "\\|^.DS_Store\\'"
                "\\|^.project\\(?:ile\\)?\\'"
                "\\|^.\\(svn\\|git\\)\\'"
                "\\|^.ccls-cache\\'"
                "\\|\\(?:\\.js\\)?\\.meta\\'"
                "\\|\\.\\(?:elc\\|o\\|pyo\\|swp\\|class\\)\\'"))
  ;; Disable the prompt about whether I want to kill the Dired buffer for a
  ;; deleted directory. Of course I do!
  (setq dired-clean-confirm-killing-deleted-buffers nil))

;;;
;;;; Editor

;;; File handling

;; Resolve symlinks when opening files, so that any operations are conducted
;; from the file's true directory (like `find-file').
(setq find-file-visit-truename t
      vc-follow-symlinks t)

;; Disable the warning "X and Y are the same file". It's fine to ignore this
;; warning as it will redirect you to the existing buffer anyway.
(setq find-file-suppress-same-file-warnings t)

;; Don't autosave files or create lock/history/backup files. We don't want
;; copies of potentially sensitive material floating around, and we'll rely on
;; git and our own good fortune instead. Fingers crossed!
(setq auto-save-default nil
      create-lockfiles nil
      make-backup-files nil)

;;; Formatting

;; Indentation
(setq-default tab-width 4
              tab-always-indent t
              indent-tabs-mode nil
              fill-column 80)

;; Word wrapping
(setq-default word-wrap t
              truncate-lines t
              truncate-partial-width-windows nil)

(setq sentence-end-double-space nil
      delete-trailing-lines nil
      require-final-newline t
      tabify-regexp "^\t* [ \t]+")  ; for :retab

;; Favor hard-wrapping in text modes
(add-hook 'text-mode-hook #'auto-fill-mode)


;;; Clipboard / kill-ring

;; Eliminate duplicates in the kill ring. That is, if you kill the same thing
;; twice, you won't have to use M-y twice to get past it to older entries in the
;; kill ring.
(setq kill-do-not-save-duplicates t)

;;
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;; Fixes the clipboard in tty Emacs by piping clipboard I/O through xclip, xsel,
;; pb{copy,paste}, wl-copy, termux-clipboard-get, or getclip (cygwin).
(add-hook 'tty-setup-hook
  (lambda ()
    (and (not (getenv "SSH_CONNECTION"))
         (require 'xclip nil t)
         (xclip-mode +1))))

;;; Built-in plugins

(use-package recentf
  ;; Keep track of recently opened files
  :ensure nil
  :demand
  :init
  (setq recentf-auto-cleanup 'never
        recentf-max-menu-items 0
        recentf-max-saved-items 200))

;;; Packages

(use-package smartparens
  ;; Auto-close delimiters and blocks as you type. It's more powerful than that,
  ;; but that is all Emacs uses it for.
  :hook ((prog-mode text-mode conf-mode) . smartparens-mode)
  ;; :commands sp-pair sp-local-pair sp-with-modes sp-point-in-comment sp-point-in-string
  :config
  ;; Load default smartparens rules for various languages
  (require 'smartparens-config))

(use-package ws-butler
  ;; a less intrusive `delete-trailing-whitespaces' on save
  :hook ((prog-mode text-mode conf-mode) . ws-butler-mode)
  :config
  (ws-butler-global-mode +1))

;;;
;;;; VC, Git
(use-package magit)

;;;
;;;; Completion

(use-package company
  :hook (after-init . global-company-mode)
  :bind (("C-SPC" . company-search-candidates))
  :init
  (setq company-minimum-prefix-length 1
        company-tooltip-limit 16
        company-idle-delay 0.0
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil
        company-tooltip-align-annotations t
        company-require-match 'never
        company-global-modes '(not erc-mode message-mode help-mode gud-mode eshell-mode shell-mode)
        company-backends '(company-capf)
        ;; company-frontends '(company-pseudo-tooltip-frontend
        ;;                     company-echo-metadata-frontend)
        )
  ;; (setq company-frontends '(company-tng-frontend company-box-frontend))
  :config (global-company-mode +1))

(use-package company-quickhelp
  :disabled
  :hook (company-mode . company-quickhelp-mode))

(use-package company-box
  :disabled
  :hook (company-mode . company-box-mode)
  :init (setq company-box-backends-colors nil
              company-box-show-single-candidate t
              company-box-max-candidates 50
              company-box-doc-delay 0.2)
  :config
  ;; Highlight `company-common'
  (defun my-company-box--make-line (candidate)
    (-let* (((candidate annotation len-c len-a backend) candidate)
            (color (company-box--get-color backend))
            ((c-color a-color i-color s-color) (company-box--resolve-colors color))
            (icon-string (and company-box--with-icons-p (company-box--add-icon candidate)))
            (candidate-string (concat (propertize (or company-common "") 'face 'company-tooltip-common)
                                      (substring (propertize candidate 'face 'company-box-candidate)
                                                 (length company-common) nil)))
            (align-string (when annotation
                            (concat " " (and company-tooltip-align-annotations
                                             (propertize " " 'display `(space :align-to (- right-fringe ,(or len-a 0) 1)))))))
            (space company-box--space)
            (icon-p company-box-enable-icon)
            (annotation-string (and annotation (propertize annotation 'face 'company-box-annotation)))
            (line (concat (unless (or (and (= space 2) icon-p) (= space 0))
                            (propertize " " 'display `(space :width ,(if (or (= space 1) (not icon-p)) 1 0.75))))
                          (company-box--apply-color icon-string i-color)
                          (company-box--apply-color candidate-string c-color)
                          align-string
                          (company-box--apply-color annotation-string a-color)))
            (len (length line)))
      (add-text-properties 0 len (list 'company-box--len (+ len-c len-a)
                                       'company-box--color s-color)
                           line)
      line))
  (advice-add #'company-box--make-line :override #'my-company-box--make-line)
  (setq company-box-icons-unknown 'fa_question_circle)

  (setq company-box-icons-elisp
        '((fa_tag :face font-lock-function-name-face) ;; Function
          (fa_cog :face font-lock-variable-name-face) ;; Variable
          (fa_cube :face font-lock-constant-face) ;; Feature
          (md_color_lens :face font-lock-doc-face))) ;; Face

  (setq company-box-icons-yasnippet 'fa_bookmark)

  (setq company-box-icons-lsp
        '((1 . fa_text_height) ;; Text
          (2 . (fa_tags :face font-lock-function-name-face)) ;; Method
          (3 . (fa_tag :face font-lock-function-name-face)) ;; Function
          (4 . (fa_tag :face font-lock-function-name-face)) ;; Constructor
          (5 . (fa_cog :foreground "#FF9800")) ;; Field
          (6 . (fa_cog :foreground "#FF9800")) ;; Variable
          (7 . (fa_cube :foreground "#7C4DFF")) ;; Class
          (8 . (fa_cube :foreground "#7C4DFF")) ;; Interface
          (9 . (fa_cube :foreground "#7C4DFF")) ;; Module
          (10 . (fa_cog :foreground "#FF9800")) ;; Property
          (11 . md_settings_system_daydream) ;; Unit
          (12 . (fa_cog :foreground "#FF9800")) ;; Value
          (13 . (md_storage :face font-lock-type-face)) ;; Enum
          (14 . (md_closed_caption :foreground "#009688")) ;; Keyword
          (15 . md_closed_caption) ;; Snippet
          (16 . (md_color_lens :face font-lock-doc-face)) ;; Color
          (17 . fa_file_text_o) ;; File
          (18 . md_refresh) ;; Reference
          (19 . fa_folder_open) ;; Folder
          (20 . (md_closed_caption :foreground "#009688")) ;; EnumMember
          (21 . (fa_square :face font-lock-constant-face)) ;; Constant
          (22 . (fa_cube :face font-lock-type-face)) ;; Struct
          (23 . fa_calendar) ;; Event
          (24 . fa_square_o) ;; Operator
          (25 . fa_arrows)) ;; TypeParameter
        ))

;;;
;;;; LSP

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'lsp-mode-map
   "K" 'lsp-describe-thing-at-point)
  :init (setq lsp-auto-guess-root t
              lsp-keymap-prefix "C-c l")
  :hook (lsp-mode . lsp-enable-which-key-integration))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config (setq lsp-ui-sideline-enable t
                lsp-ui-sideline-show-hover nil
                lsp-ui-doc-enable nil ; I'm gonna open these manually
                lsp-ui-doc-position 'bottom
                lsp-lens-enable t))

; VERY COOL but I need a nice home for it
(add-to-list 'display-buffer-alist
             '((lambda (buffer _) (with-current-buffer buffer
                                    (seq-some (lambda (mode)
                                                (derived-mode-p mode))
                                              '(help-mode))))
               (display-buffer-reuse-window display-buffer-below-selected)
               (reusable-frames . visible)
               (window-height . 0.33)))

;;;
;;;; Org

(use-package org
  :init
  (with-no-warnings
    (custom-declare-face 'my-todo-active  '((t (:inherit (bold font-lock-constant-face org-todo)))) "")
    (custom-declare-face 'my-todo-project '((t (:inherit (bold font-lock-builtin-face org-todo)))) "")
    (custom-declare-face 'my-todo-onhold  '((t (:inherit (bold warning org-todo)))) ""))
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "PROJ(p)"
           "STRT(s)"
           "WAIT(w)"
           "HOLD(w)"
           "|"
           "DONE(d)"
           "KILL(k)"))
        org-todo-keyword-faces
        '(("STRT" . my-todo-active)
          ("WAIT" . my-todo-onhold)
          ("HOLD" . my-todo-onhold)
          ("PROJ" . my-todo-project))
        org-agenda-files '("~/documents/todos/agenda.org" "~/documents/todos/uni-agenda.org")))

(use-package evil-org
  :after (org evil)
  :hook (org-mode . evil-org-mode)
  :hook (evil-org-mode . (lambda () (evil-org-set-key-theme)))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;;;
;;;; Flycheck
(use-package flycheck
  :hook (lsp-mode . flycheck-mode))


;;;
;;;; Nix

(use-package nix-mode
  :mode "\\.nix\\'")

;;;
;;;; Haskell

(use-package haskell-mode
  :general
  (my-general-localleader
    :keymaps 'haskell-mode-map
    "i" 'haskell-interactive-switch
    "l f" 'haskell-process-load-file)
  :init (setq haskell-process-auto-import-loaded-modules t
              haskell-process-show-overlays nil)) ; redundant with flycheck

(use-package lsp-haskell
  :config
  (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper"))

;;;
;;;; Common Lisp

(use-package slime-company
  :after (slime company)
  :init
  (setq slime-company-completion 'fuzzy))

(use-package slime
  :hook (slime-mode . (lambda () (unless (slime-connected-p) (save-excursion (slime)))))
  :general
  (my-general-localleader
    :keymaps 'lisp-mode-map
    "c d" 'slime-compile-defun
    "c f" 'slime-compile-file
    "c l" 'slime-compile-and-load-file
    "c r" 'slime-compile-region
    "e d" 'slime-eval-defun
    "e b" 'slime-eval-buffer
    "l f" 'slime-load-file)
  :init
  (setq inferior-lisp-program "sbcl")
  :config
  (slime-setup '(slime-fancy slime-company)))

;;;
;;;; JS

(use-package js2-mode)
(use-package web)

;;;
;;;; W/E filetypes

(use-package json-mode
  :mode "\\.json$")


;(use-package repl-toggle
;  :ensure t
;  :preface
;  (defun clojure-repl ()
;    "Open a Clojure REPL."
;    (interactive)
;    (pop-to-buffer (cider-current-repl nil 'ensure)))
;
;  (defun js-repl ()
;    "Open a JavaScript REPL."
;    (interactive)
;    (if (indium-client-process-live-p) (indium-switch-to-repl-buffer) (nodejs-repl)))
;
;  (defun lua-repl ()
;    "Open a Lua REPL."
;    (interactive)
;    (pop-to-buffer (process-buffer (lua-get-create-process))))
;  :general
;  (:keymaps
;   'prog-mode-map
;   :prefix local-leader-key
;   "r" 'rtog/toggle-repl)
;  :init
;  (setq rtog/goto-buffer-fun 'pop-to-buffer)
;  (setq rtog/mode-repl-alist
;        '((emacs-lisp-mode . ielm)
;          (clojure-mode . clojure-repl)
;          (elm-mode . elm-repl-load)
;          (go-mode . gorepl-run)
;          (js-mode . js-repl)
;          (lisp-mode . slime)
;          (lua-mode . lua-repl)
;          (nix-mode . nix-repl)
;          (racket-mode . racket-repl)
;                    (typescript-mode . run-ts))))
