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
  ;; Exclude no-littering files from recentf.
  (require 'recentf)
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  ;; If auto-save file has to be stored, it goes to var directory.
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  ;; Don't save customizations to init.el!
  (setq custom-file (no-littering-expand-etc-file-name "custom.el")))

;;
;;; Optimizations

(setq gc-cons-threshold 100000000)

(use-package gcmh
  :hook
  (after-init-hook . gcmh-mode)
  :init
  (setq gcmh-idle-delay 5
        gcmh-high-cons-threshold (* 16 1024 1024))
  :config (gcmh-mode 1))

;; Increase the amount of data which Emacs reads from the process. Default is only 4k.
(setq read-process-output-max (* 1024 1024)) ;; 1mb

(setq bidi-inhibit-bpa t)
(setq redisplay-dont-pause t)

;;;
;;;; Keybindings

(defvar my-leader-key "SPC"
  "My evil leader.")

(defvar my-localleader-key "SPC m"
  "The localleader prefix key, for major-mode specific commands.")

;;; General

(use-package general
  :demand
  :config
  (general-create-definer my-general-leader
    :states '(normal visual)
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

;;
;;; Evil Stuff

(use-package evil
  :demand
  :init
  (setq evil-want-C-i-jump (or (daemonp) (display-graphic-p))
        evil-want-C-u-scroll t
        evil-want-C-w-scroll t
        evil-want-Y-yank-to-eol t
        evil-want-abbrev-expand-on-insert-exit nil
        evil-respect-visual-line-mode t
        evil-want-visual-char-semi-exclusive t
        ;; more vim-like behavior
        evil-symbol-word-search t
        ;; undo tool to use
        evil-undo-system 'undo-redo ; undo-redo as of emacs28
        ;; for evil-collection
        evil-want-integration t ; This is optional since it's already set to t by default.
        evil-want-keybinding nil)
  :config
  (evil-mode 1))

(my-general-leader
  "w" 'save-buffer
  "t" 'tab-new
  "q" 'evil-quit)

(use-package evil-collection
  :after evil
  :demand
  :init
  (setq evil-collection-setup-minibuffer t
        evil-collection-company-use-tng nil
        evil-collection-want-unimpaired-p nil)
  :config
  (evil-collection-init))

(use-package evil-nerd-commenter
  :general
  (my-general-leader
    "c i" 'evilnc-comment-or-uncomment-lines
    "c p" 'evilnc-comment-or-uncomment-paragraphs
    "c r" 'comment-or-uncomment-region
    "c y" 'evilnc-copy-and-comment-lines)
  :config (evilnc-default-hotkeys nil t))

(use-package evil-surround
  :hook ((prog-mode text-mode conf-mode) . evil-surround-mode)
  :config
  (global-evil-surround-mode 1))

(use-package evil-matchit
  :hook ((prog-mode text-mode conf-mode) . evil-matchit-mode)
  :config
  (global-evil-matchit-mode 1))

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

(use-package avy)

(use-package counsel
  :general
  (general-define-key
   "M-x" 'counsel-M-x)
  (my-general-leader
    "/" 'swiper
    "l" 'counsel-fzf
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
;; (add-to-list 'default-frame-alist '(font . "SpaceMono Nerd Font-10"))
;; (add-to-list 'default-frame-alist '(font . "VictorMono Nerd Font-11"))
(add-to-list 'default-frame-alist '(font . "FantasqueSansMono Nerd Font-12"))

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
  :init
  (setq show-paren-delay 0.1
        show-paren-highlight-openparen t
        show-paren-when-point-inside-paren t
        show-paren-when-point-in-periphery t)
  :config (show-paren-mode +1))

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
          ("BUG"        bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

;; Highlight brackets according to their depth
(use-package rainbow-delimiters
  :disabled
  :hook ((prog-mode . rainbow-delimiters-mode)
         (sly-mrepl-mode . rainbow-delimiters-mode))
  :init
  ;; Helps us distinguish stacked delimiter pairs, especially in parentheses-drunk
  ;; languages like Lisp.
  (setq rainbow-delimiters-max-face-count 7))

(use-package doom-themes
  :init
  ;; Global settings (defaults)
  (load-theme 'doom-tomorrow-night t)
  :config
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :init
  (unless after-init-time
    ;; prevent flash of unstyled modeline at startup
    (setq-default mode-line-format nil))
  ;; Set these early so they don't trigger variable watchers
  (setq doom-modeline-bar-width 3
        ;; How tall the mode-line should be. It's only respected in GUI.
        ;; If the actual char height is larger, it respects the actual height.
        doom-modeline-height 25
        ;; Whether display icons in the mode-line.
        ;; While using the server mode in GUI, should set the value explicitly.
        doom-modeline-icon (display-graphic-p)
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
  :disabled
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

;; set up emacs clipboard in tty
(use-package clipetty
  :hook (after-init . global-clipetty-mode))

;;; Built-in plugins

(use-package recentf
  ;; Keep track of recently opened files
  :ensure nil
  :demand
  :init
  (setq recentf-auto-cleanup 'never
        recentf-max-menu-items 0
        recentf-max-saved-items 200)
  :config (recentf-mode 1))

(use-package compilation
  :ensure nil
  ;; turn on ansi color interpretation in compilation buffer
  :hook (compilation-filter . (lambda ()
                                (require 'ansi-color)
                                (let ((inhibit-read-only t))
                                  (ansi-color-apply-on-region (point-min) (point-max))))))

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
  :init
  (setq company-minimum-prefix-length 1
        company-tooltip-limit 16
        company-idle-delay 0.0
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil
        company-tooltip-align-annotations t
        company-require-match 'never))

;; FIXME bad with lsp-ui
(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package company-quickhelp
  :disabled
  :hook (company-mode . company-quickhelp-mode))

(use-package company-box
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

(use-package projectile)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'lsp-mode-map
   "K" 'lsp-describe-thing-at-point)
  (my-general-leader
    :keymaps 'lsp-mode-map
    "c a" 'lsp-execute-code-action
    "g r" 'lsp-find-references
    "g D" 'lsp-find-declaration
    "g i" 'lsp-find-implementation
    "n"   'lsp-rename
    "f"   'lsp-format-buffer
    "c l" 'lsp-avy-lens)
  :init
  (setq lsp-auto-guess-root nil
        lsp-idle-delay 0.300
        lsp-clients-clangd-executable "clangd"
        lsp-keymap-prefix "C-c l")
  (setq lsp-enable-snippet t)
  :hook (lsp-mode . lsp-enable-which-key-integration))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config (setq lsp-ui-sideline-enable t
                lsp-ui-sideline-show-hover nil
                lsp-ui-doc-enable nil ; I'm gonna open these manually
                lsp-ui-doc-position 'bottom
                lsp-lens-enable t))

;; VERY COOL but I need a nice home for it
(add-to-list 'display-buffer-alist
             '((lambda (buffer _) (with-current-buffer buffer
                                    (seq-some (lambda (mode)
                                                (derived-mode-p mode))
                                              '(help-mode))))
               (display-buffer-reuse-window display-buffer-below-selected)
               (reusable-frames . visible)
               (window-height . 0.33)))

(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))

(use-package lsp-treemacs
  ;; :general
  ;; (my-general-leader
  ;;   "l s" 'lsp-treemacs-symbols
  ;;   "l d" 'lsp-treemacs-errors-list)
  )
(use-package lsp-ivy
  :general
  (my-general-leader
    :keymaps 'lsp-mode-map
    "i w" 'lsp-ivy-workspace-symbol))

(use-package tree-sitter)

(use-package tree-sitter-langs)

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
(use-package flycheck :hook (lsp-mode . flycheck-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'lsp-mode-map
   "]d" 'flycheck-next-error
   "[d" 'flycheck-previous-error)
  (my-general-leader
    "d" 'flycheck-list-errors))

;;;
;;;; Nix

(use-package nix-mode :mode "\\.nix\\'")

;;;
;;;; Haskell

(use-package haskell-mode
  :hook (haskell-mode . lsp-deferred)
  :hook (haskell-literate-mode . lsp-deferred)
  :general
  (my-general-localleader
    :keymaps 'haskell-mode-map
    "i" 'haskell-interactive-switch
    "l f" 'haskell-process-load-file)
  :init (setq haskell-process-auto-import-loaded-modules t
              haskell-process-show-overlays nil)) ; redundant with flycheck?

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
;;;; Web

(use-package web-mode
  :hook (html-mode . web-mode)
  :hook (web-mode . lsp-deferred))
(use-package emmet-mode)

;;;
;;;; JS

(use-package js2-mode
  :mode "\\.js$"
  :hook (js2-mode . lsp-deferred))

;;;
;;;; Python

(use-package python-mode
  :hook (python-mode . lsp-deferred)
  :init (setq python-shell-interpreter "python3"))

(use-package virtualenvwrapper)

;;;
;;;; Java

(use-package lsp-java
  :hook (java-mode . lsp))

(use-package dap-java :ensure nil)

;;;
;;;; W/E filetypes

(use-package lua-mode)
(use-package json-mode :mode "\\.json$")
(use-package vimrc-mode)
(use-package ess)
(use-package markdown-mode
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; idk how this block works
;; (use-package polymode)
;; (use-package poly-markdown)
;; (add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

(use-package direnv :config (direnv-mode))
