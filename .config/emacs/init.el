;; Auto-tangle

;; All changes should be done in =init.org=, *not* in =init.el=. Changes to =init.el= will be
;; overwritten.

;; We're using lexical binding for the init file, which is specified in a header.


;; [[file:init.org::*Auto-tangle][Auto-tangle:1]]
;;; -*- lexical-binding: t -*-
;;; THIS IS A GENERATED FILE; see init.org
;; Auto-tangle:1 ends here



;; After first run, =init.el= should mirror the source blocks in =init.org=. To regenerate
;; =init.el=, run =org-babel-tangle= (=C-c C-v t=); for convenience, this is done automatically
;; on saving the buffer.

;; I originally had this byte-compile the file as well, which turned out to be a huge pain
;; when the file was valid, but wouldn't byte-compile because it referred to something from
;; a package that hadn't been loaded/installed yet. This resulted in Emacs getting stuck on
;; the byte-compiled version.


;; [[file:init.org::*Auto-tangle][Auto-tangle:2]]
(defun my/tangle-init ()
  "If the current buffer is 'init.org' the code blocks are
tangled, and the tangled file is compiled."
  (when (equal (buffer-file-name)
               (expand-file-name (concat user-emacs-directory "init.org")))
    ;; Avoid running hooks when tangling
    (let ((prog-mode-hook nil)
          (org-confirm-babel-evaluate nil))
      (org-babel-tangle)
      (org-html-export-to-html))))

(add-hook 'after-save-hook 'my/tangle-init)
;; Auto-tangle:2 ends here



;; Since =init.el= gets overwritten constantly, Emacs adding customizations to it is a bit
;; futile. These are punted off into another file.


;; [[file:init.org::*Auto-tangle][Auto-tangle:3]]
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file t)
;; Auto-tangle:3 ends here

;; Machine-local settings support

;; Machine-local settings live in a separate file. Load =local.el= if it exists, after the
;; init file is complete.


;; [[file:init.org::*Machine-local settings support][Machine-local settings support:1]]
(defun my/load-local-init ()
  (let ((local-file (concat user-emacs-directory "/local-" (system-name) ".el")))
    (message local-file)
    (when (file-exists-p local-file)
      (load-file local-file))))

(add-hook 'after-init-hook 'my/load-local-init)
;; Machine-local settings support:1 ends here



;; Additionally, some behavior is Windows-only or macOS-only, so define convenient
;; constants to test against.


;; [[file:init.org::*Machine-local settings support][Machine-local settings support:2]]
(defconst *my/is-macos*
  (memq window-system '(mac ns))
  "True if Emacs is running under macOS")

(defconst *my/is-winnt*
  (or (string= "windows-nt" system-type)
      (string= "cygwin" system-type))
  "True if Emacs is running under Windows")
;; Machine-local settings support:2 ends here



;; The GNU versions of some command-line tools support extra options. We use the GNU
;; versions on Linux and Windows, but not macOS.


;; [[file:init.org::*Machine-local settings support][Machine-local settings support:3]]
(defconst *my/is-gnu-like*
  (or *my/is-winnt*  ; You're probably installing GNU-like instead of BSD-like
                     ; tools under Windows.
      (string-prefix-p "gnu" (symbol-name system-type)))
  "True if we expect GNU-like coreutils")
;; Machine-local settings support:3 ends here

;; Package Management

;; First, we have to give GNUTLS some magic options so we can connect to ELPA.


;; [[file:init.org::*Package Management][Package Management:1]]
;; (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
;; Package Management:1 ends here



;; Package management uses [[https://github.com/raxod502/straight.el][straight.el]], for a more reliable cross-machine experience.


;; [[file:init.org::*Package Management][Package Management:2]]
(setq straight-use-package-by-default t)
(setq straight-recipes-gnu-elpa-use-mirror t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
;; Package Management:2 ends here



;; Main package management is through =use-package=, but that has to be installed first.


;; [[file:init.org::*Package Management][Package Management:3]]
(setq use-package-verbose t)
(straight-use-package 'use-package)
(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)
;; Package Management:3 ends here

;; Libraries


;; [[file:init.org::*Libraries][Libraries:1]]
(use-package dash :config (dash-enable-font-lock))
(use-package delight)
;; Libraries:1 ends here

;; Platform Fixes

;; On macOS, GUI applications tend to miss out on environment variables. We can pull these
;; from the shell instead.


;; [[file:init.org::*Platform Fixes][Platform Fixes:1]]
(use-package exec-path-from-shell
  :if *my/is-macos*
  :config
  (exec-path-from-shell-initialize))
;; Platform Fixes:1 ends here



;; We only expect GNU coreutils on some systems. Tell Emacs about systems where we don't
;; think we'll have them.


;; [[file:init.org::*Platform Fixes][Platform Fixes:2]]
(when (not *my/is-gnu-like*)
  (setq dired-use-ls-dired nil))
;; Platform Fixes:2 ends here

;; Safety & Backups

;; By default Emacs scatters backup files all over the shop. Instead, we'd prefer for them
;; to all be in one directory.


;; [[file:init.org::*Safety & Backups][Safety & Backups:1]]
(setq my-backup-directory (concat user-emacs-directory "backups"))
(when (not (file-exists-p my-backup-directory))
  (make-directory my-backup-directory))
(setq backup-directory-alist `(("." . ,my-backup-directory)))
;; Safety & Backups:1 ends here



;; Keep multiple versions of backup files. We can always delete them later if they prove to
;; be a pain.


;; [[file:init.org::*Safety & Backups][Safety & Backups:2]]
(setq backup-by-copying t)    ; this is a bit safer
(setq version-control t)      ; numbered backups
(setq delete-old-versions t)  ; manage excess backups
(setq kept-old-versions 6)
(setq kept-new-versions 9)
;; Safety & Backups:2 ends here



;; Instead of instantly consigning files to oblivion, move them to the trash.


;; [[file:init.org::*Safety & Backups][Safety & Backups:3]]
(setq delete-by-moving-to-trash t)
;; Safety & Backups:3 ends here

;; History


;; [[file:init.org::*History][History:1]]
(setq savehist-file (concat user-emacs-directory "savehist"))
(savehist-mode 1)
(setq history-length t)
(setq history-delete-duplicates t)
(setq savehist-save-minibuffer-history t)
(setq savehist-additional-variables
      '(kill-ring
        search-ring
        regexp-search-ring))
(setq recentf-max-saved-items 100)
(recentf-mode 1)
;; History:1 ends here

;; Visual Experience


;; [[file:init.org::*Visual Experience][Visual Experience:1]]
(setq inhibit-startup-message t)
(setq global-linum-mode nil)  ; maybe?
;; Visual Experience:1 ends here



;; Modes that need to be enabled/disabled:


;; [[file:init.org::*Visual Experience][Visual Experience:2]]
(tool-bar-mode 0)      ; no toolbars
(scroll-bar-mode 0)    ; no scrollbars
(blink-cursor-mode 0)  ; no blinking cursor
(show-paren-mode 1)
(global-prettify-symbols-mode 0)
;; Visual Experience:2 ends here



;; Font face and size. Let me tell you how much I love this font.


;; [[file:init.org::*Visual Experience][Visual Experience:3]]
(add-to-list 'default-frame-alist
             '(font . "Fantasque Sans Mono-10"))

(set-face-attribute 'variable-pitch nil
                    :family "Source Serif Pro"
                    :height 1.25)

(set-face-attribute 'font-lock-comment-face nil
                    :family "Source Serif Pro"
                    :slant 'normal
                    :height 1.1)
;; Visual Experience:3 ends here



;; Highlight trailing whitespace, but not in like, every single buffer. In particular, we
;; want to exclude the ivy buffers.


;; [[file:init.org::*Visual Experience][Visual Experience:4]]
(setq-default show-trailing-whitespace t)

(defun my/hide-trailing-whitespace ()
  (setq show-trailing-whitespace nil))

(add-hook 'minibuffer-setup-hook
          'my/hide-trailing-whitespace)
;; Visual Experience:4 ends here



;; Display emojis! These are crucial.


;; [[file:init.org::*Visual Experience][Visual Experience:5]]
(use-package emojify
    :init
    (progn
      (setq emojify-emoji-styles '(unicode))
      (setq emojify-display-style 'image))
    :config
    (progn
      (global-emojify-mode 1)
      (global-emojify-mode-line-mode 1)))
;; Visual Experience:5 ends here



;; Ligatures are nice, and Fantasque Sans Mono supports them. Specifically, it supports
;; them for the following characters:


;; [[file:init.org::*Visual Experience][Visual Experience:6]]
(defconst my/fantasque-ligatures
  '("!=" "!=="
    "==" "===" "=>" "==>" "=>>" "=/=" "=<<"
    "->" "-->" "->>" "-<" "-<<"
    "<-" "<-<" "<<-" "<--" "<->" "<=<" "<<=" "<==" "<=>" "<~~" "<~" "<<<"
    "<<" "<=" "<~>" "<>" "<|||" "<||" "<|" "<|>" "<!--"
    ">->" ">=>" ">>=" ">>-" ">-" ">=" ">>" ">>>"
    "~~" "~>" "~~>"
    "|>" "||>" "|||>" "||"
    "::" "&&"
    "//" "/*" "/**/"
    "*/"))
;; Visual Experience:6 ends here



;; Machinery for setting ligatures up:


;; [[file:init.org::*Visual Experience][Visual Experience:7]]
(defun my/group-by-first-char (strs)
  (let ((strs (sort strs 'string<))
        (tbl))
    (dolist (str strs tbl)
      (let* ((char (string-to-char (substring str 0 1))))
        (if (or (not tbl) (/= (car (car tbl)) char))
            (setq tbl (cons (cons char (list str)) tbl))
          (setcdr (car tbl) (cons str (cdr (car tbl)))))))))

(defun my/enable-compositions (ligatures)
  (let ((regexps (mapcar (lambda (comp)
                           (cons (car comp) (regexp-opt (cdr comp))))
                         (my/group-by-first-char ligatures))))
    (dolist (r regexps)
      (let ((char (car r))
            (comps (cdr r)))
        (set-char-table-range composition-function-table char
                              `([,comps 0 font-shape-gstring]))))))

(my/enable-compositions my/fantasque-ligatures)
;; Visual Experience:7 ends here



;; NYAN NYAN NYAN


;; [[file:init.org::*Visual Experience][Visual Experience:8]]
(use-package nyan-mode
  :config (nyan-mode 1))
;; Visual Experience:8 ends here

;; Better Defaults

;; They're better.


;; [[file:init.org::*Better Defaults][Better Defaults:1]]
(use-package better-defaults)
;; Better Defaults:1 ends here

;; Input


;; [[file:init.org::*Input][Input:1]]
(setq default-input-method "TeX")
(setq initial-scratch-message nil)
(setq sentence-end-double-space nil)
(setq-default fill-column 88)
(setq-default truncate-lines nil)  ; visual wrap
(global-visual-line-mode 1)
(setq-default auto-fill-function 'do-auto-fill)
(fset 'yes-or-no-p 'y-or-n-p)  ; laziness enhancer

(use-package emacs
  :delight
  (auto-fill-function " \N{LEFT RIGHT ARROW}")
  (visual-line-mode " \N{MIDLINE HORIZONTAL ELLIPSIS}"))

(delete-selection-mode 1)
(global-auto-revert-mode 1)
;; Input:1 ends here



;; Use =utf-8= by default, because it's the 21st century and all.


;; [[file:init.org::*Input][Input:2]]
(set-language-environment "UTF-8")
(setq-default buffer-file-coding-system 'utf-8-unix)
;; Input:2 ends here

;; TODO Smartparens
;;    This wants to be global?


;; [[file:init.org::*Smartparens][Smartparens:1]]
(use-package smartparens
  :config
  (require 'smartparens-config))
;; Smartparens:1 ends here

;; Autocomplete


;; [[file:init.org::*Autocomplete][Autocomplete:1]]
(use-package company
  :delight (company-mode " \N{FACTORY}")
  :config
  (global-company-mode))
;; Autocomplete:1 ends here

;; Syntax Checking


;; [[file:init.org::*Syntax Checking][Syntax Checking:1]]
(use-package flycheck
  :delight (flycheck-mode " \N{BUTTERFLY}")
  :commands flycheck-mode)
;; Syntax Checking:1 ends here

;; Which-key


;; [[file:init.org::*Which-key][Which-key:1]]
(use-package which-key
  :delight which-key-mode
  :config (which-key-mode 1))
;; Which-key:1 ends here

;; Powerline

;; Powerline, for fancier modelines. Possibly also gives away that I'm a VIM refugee.


;; [[file:init.org::*Powerline][Powerline:1]]
(use-package powerline
  :config (powerline-default-theme))
;; Powerline:1 ends here

;; Mixed-DPI Toggle

;; Because I have a mixed-DPI setup and I'm under X, I need to be able to rescale an entire
;; Emacs frame at a time on the fly, so I also include keybindings for that. This can be
;; hooked into for e.g. fixing treemacs icons.


;; [[file:init.org::*Mixed-DPI Toggle][Mixed-DPI Toggle:1]]
(defvar my/toggle-face-height-hook nil
  "Called when toggling the face height for mixed-DPI setups")

(defun my/current-default-face-height ()
  (face-attribute 'default :height (selected-frame)))

(defun my/toggle-face-height ()
  (interactive)

  (set-face-attribute 'default (selected-frame) :height
                      (if (> (my/current-default-face-height) 80) 60 100))
  (run-hooks 'my/toggle-face-height-hook))

(global-set-key (kbd "C-x T s") 'my/toggle-face-height)
;; Mixed-DPI Toggle:1 ends here

;; Color scheme


;; [[file:init.org::*Color scheme][Color scheme:1]]
(setq my-light-theme 'gruvbox-light-soft)
(setq my-dark-theme 'gruvbox-dark-soft)
(setq my-initial-theme my-dark-theme)
;; Color scheme:1 ends here



;; This provides a function which observes the current theme, and toggles it to light if it
;; is dark.


;; [[file:init.org::*Color scheme][Color scheme:2]]
(defun my/toggle-theme ()
  (interactive)

  (let ((is-dark (seq-contains custom-enabled-themes my-dark-theme)))
    (dolist (theme custom-enabled-themes)
      (disable-theme theme))
    (load-theme (if is-dark my-light-theme my-dark-theme) t)))
;; Color scheme:2 ends here



;; If we're using a windowing system, then apply the startup theme and bind a toggle key.


;; [[file:init.org::*Color scheme][Color scheme:3]]
(use-package gruvbox-theme
  :if window-system
  :demand t
  :bind ("C-x T t" . my/toggle-theme)
  :config
  (load-theme my-initial-theme t))
;; Color scheme:3 ends here

;; Undo-tree


;; [[file:init.org::*Undo-tree][Undo-tree:1]]
(use-package undo-tree
  :delight undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))
;; Undo-tree:1 ends here

;; Window Management


;; [[file:init.org::*Window Management][Window Management:1]]
(use-package ace-window
  :bind ("M-o" . ace-window))
;; Window Management:1 ends here

;; Evil


;; [[file:init.org::*Evil][Evil:1]]
(use-package evil
  :config
  (evil-mode 1))
;; Evil:1 ends here

;; Projectile


;; [[file:init.org::*Projectile][Projectile:1]]
(setq my-project-type-glyph-alist
      '((nil . "\N{NO ENTRY SIGN}")
        (generic . "\N{GLOBE WITH MERIDIANS}")
        (cmake . "▲")
        (dune . "\N{BACTRIAN CAMEL}")
        (zig . "\N{CIRCLED LATIN CAPITAL LETTER Z}")))

(defun my/project-type-glyph ()
  (let ((type (projectile-project-type)))
    (cdr
     (or (assoc type my-project-type-glyph-alist)
         (cons type type)))))
;; Projectile:1 ends here

;; [[file:init.org::*Projectile][Projectile:2]]
(use-package projectile
  :demand
  :after ivy
  :delight (projectile-mode
            (:eval (format " \N{ROCKET}\N{MIDDLE DOT}%s" (my/project-type-glyph))))
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (progn
    (projectile-mode 1)
    (projectile-discover-projects-in-search-path)
    (setq projectile-completion-system 'ivy)))
;; Projectile:2 ends here

;; Ivy


;; [[file:init.org::*Ivy][Ivy:1]]
(use-package counsel
  :after ivy
  :delight counsel-mode
  :config (counsel-mode 1))

(use-package ivy
  :demand t
  :delight ivy-mode
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :custom
  (ivy-virtual-abbreviate 'full
                          ivy-rich-switch-buffer-align-virtual-buffer t
                          ivy-rich-path-style 'abbrev)
  :config
  (progn
    (ivy-set-display-transformer 'ivy-switch-buffer
                                 'ivy-rich-switch-buffer-transformer)
    (ivy-rich-mode 1)))

(use-package swiper
  :after ivy
  :bind (("\C-s" . swiper)))
;; Ivy:1 ends here

;; Treemacs


;; [[file:init.org::*Treemacs][Treemacs:1]]
(use-package treemacs
  :config
  (progn
    (treemacs-git-mode 'deferred)
    (treemacs-filewatch-mode 1)
    (define-key treemacs-mode-map [mouse-1]
      #'treemacs-single-click-expand-action)))
;; Treemacs:1 ends here

;; [[file:init.org::*Treemacs][Treemacs:2]]
(use-package treemacs-projectile
  :after (treemacs projectile))
;; Treemacs:2 ends here

;; [[file:init.org::*Treemacs][Treemacs:3]]
(use-package treemacs-magit
  :after (treemacs magit))
;; Treemacs:3 ends here

;; [[file:init.org::*Treemacs][Treemacs:4]]
(use-package treemacs-evil
  :after (treemacs evil))
;; Treemacs:4 ends here



;; Bind =C-x t= so that it moves the cursor to the treemacs buffer, opening it if necessary.
;; Supplying the universal argument toggles the treemacs buffer instead.


;; [[file:init.org::*Treemacs][Treemacs:5]]
(defun my/treemacs-command (arg)
  (interactive "P")
  (if (> (prefix-numeric-value arg) 1)
      (treemacs)
    (treemacs-select-window)))

(global-set-key (kbd "C-x t") 'my/treemacs-command)
;; Treemacs:5 ends here



;; Rescale treemacs icons when we toggle the font-size for mixed-DPI.


;; [[file:init.org::*Treemacs][Treemacs:6]]
(add-hook 'my/toggle-face-height-hook
          #'(lambda ()
              (treemacs-resize-icons
               (if (> (my/current-default-face-height) 80) 22 11))))
;; Treemacs:6 ends here



;; Open Treemacs on startup automatically.


;; [[file:init.org::*Treemacs][Treemacs:7]]
(treemacs-select-window)
;; Treemacs:7 ends here

;; Code Folding


;; [[file:init.org::*Code Folding][Code Folding:1]]
(use-package origami
  :after evil
  :config
  (progn
    (evil-define-key 'normal origami-mode-map "zo" 'origami-open-node)
    (evil-define-key 'normal origami-mode-map "zO" 'origami-open-node-recursively)
    (evil-define-key 'normal origami-mode-map "zc" 'origami-close-node)
    (evil-define-key 'normal origami-mode-map "zC" 'origami-close-node-recursively)
    (evil-define-key 'normal origami-mode-map "za" 'origami-forward-toggle-node)
    (evil-define-key 'normal origami-mode-map "zA" 'origami-recursively-toggle-node)
    (evil-define-key 'normal origami-mode-map "zv" 'origami-show-node)
    (evil-define-key 'normal origami-mode-map "zx" 'origami-reset)
    (evil-define-key 'normal origami-mode-map "zm" 'origami-close-all-nodes)
    (evil-define-key 'normal origami-mode-map "zr" 'origami-open-all-nodes)
    (global-origami-mode)))
;; Code Folding:1 ends here

;; TRAMP


;; [[file:init.org::*TRAMP][TRAMP:1]]
(setq-default explicit-shell-file-name "/bin/bash")
;; TRAMP:1 ends here

;; LSP


;; [[file:init.org::*LSP][LSP:1]]
(use-package lsp-mode
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package lsp-treemacs
  :commands lsp-treemacs-errors-list)
;; LSP:1 ends here

;; Org


;; [[file:init.org::*Org][Org:1]]
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :bind (("C-c l" . org-store-link)
         ("C-c a" . org-agenda)
         ("C-c c" . org-capture))
  :init
  (progn
    (setq org-log-done t)
    (setq org-hide-emphasis-markers t)))
;; Org:1 ends here

;; [[file:init.org::*Org][Org:2]]
(use-package htmlize
  :commands (htmlize-buffer
             htmlize-region
             htmlize-file
             htmlize-many-files
             htmlize-many-files-dired))
;; Org:2 ends here

;; [[file:init.org::*Org][Org:3]]
(use-package org-variable-pitch
  :hook (org-mode . org-variable-pitch--enable)
  :config
  (set-face-attribute 'org-variable-pitch-fixed-face nil
                      :family (org-variable-pitch--get-fixed-font)
                      :height 0.8)
  (set-face-attribute 'org-level-1 nil :height (+ 1.0 (expt 0.5 0)))
  (set-face-attribute 'org-level-2 nil :height (+ 1.0 (expt 0.5 1)))
  (set-face-attribute 'org-level-3 nil :height (+ 1.0 (expt 0.5 2)))
  (set-face-attribute 'org-level-4 nil :height (+ 1.0 (expt 0.5 3)))
  (set-face-attribute 'org-level-5 nil :height (+ 1.0 (expt 0.5 4)))
  (set-face-attribute 'org-level-6 nil :height (+ 1.0 (expt 0.5 5)))
  (set-face-attribute 'org-level-7 nil :height (+ 1.0 (expt 0.5 6)))
  (set-face-attribute 'org-level-8 nil :height (+ 1.0 (expt 0.5 7))))
;; Org:3 ends here

;; [[file:init.org::*Org][Org:4]]
(use-package org-d20
  :commands org-d20-mode)
;; Org:4 ends here

;; Git


;; [[file:init.org::*Git][Git:1]]
(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (progn
    (add-hook 'magit-mode-hook #'(lambda () (origami-mode 0)))))
;; Git:1 ends here

;; [[file:init.org::*Git][Git:2]]
(use-package evil-magit
  :after (evil magit))
;; Git:2 ends here

;; [[file:init.org::*Git][Git:3]]
(use-package git-gutter-fringe
  :delight git-gutter-mode
  :config (global-git-gutter-mode 1))
;; Git:3 ends here

;; C/C++


;; [[file:init.org::*C/C++][C/C++:1]]
(use-package irony
  :hook (((c++-mode c-mode objc-mode) . irony-mode)
         (irony-mode . irony-cdb-autosetup-compile-options))
  :init
  (progn
    (when (string= "windows-nt" system-type)
      (setq exec-path (append exec-path '("~/scoop/apps/llvm/10.0.0/bin"))))
    (when (boundp 'w32-pipe-read-delay)
      (setq w32-pipe-read-delay 0))
    (when (boundp 'w32-pipe-buffer-size)
      (setq irony-server-w32-pipe-buffer-size (* 64 1024)))))

(use-package cmake-ide
  :demand t
  :config (cmake-ide-setup))
;; C/C++:1 ends here

;; MATLAB

;; Normally, =.m= files are treated as Objective-C files. I don't really do any ObjC, so
;; they're going to be treated as MATLAB files instead.


;; [[file:init.org::*MATLAB][MATLAB:1]]
(use-package matlab-mode
  :mode "\\.m\\'"
  :init
  (progn
    (setq matlab-indent-function t)  ; TODO figure out what this does
    (setq matlab-shell-command "/usr/local/bin/matlab")))
;; MATLAB:1 ends here

;; Python

;; Python development environment using Elpy.


;; [[file:init.org::*Python][Python:1]]
(use-package elpy
  :delight (elpy-mode " \N{SNAKE}") (highlight-indentation-mode " \N{STRAIGHT RULER}")
  :defer t
  :init (advice-add 'python-mode :before 'elpy-enable)
  :config
  (progn
    ;; replace flymake with flycheck
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))
;; Python:1 ends here



;; Automatically format Python code on save using the Black formatter.


;; [[file:init.org::*Python][Python:2]]
(use-package blacken
  :delight (blacken-mode " \N{WAVING BLACK FLAG}")
  :hook (elpy-mode . blacken-mode))
;; Python:2 ends here

;; TODO Ocaml

;; #+NAME: packages/ocaml
;; | Package        | Description     |
;; |----------------+-----------------|
;; | ggtags         |                 |


;; [[file:init.org::*Ocaml][Ocaml:1]]
(defun my/ocaml/init-opam ()
  (if (executable-find "opam")
      (let ((share (string-trim-right
                    (with-output-to-string
                      (with-current-buffer
                          standard-output
                        (process-file
                         shell-file-name nil '(t nil) nil shell-command-switch
                         "opam config var share"))))))
        (cond ((string= "" share)
               (message "warning: `%s' output empty string." "opam config var share"))
              ((not (file-directory-p share))
               (message "%s" "warning: opam share directory does not exist."))
              (t (setq opam-share share
                       opam-load-path (concat share "/emacs/site-lisp"))
                 (add-to-list 'load-path opam-load-path))))
    (unless (executable-find "ocamlmerlin")
      (message "warning: cannot find `%s' or `%s' executable." "opam" "merlin"))))
;; Ocaml:1 ends here

;; [[file:init.org::*Ocaml][Ocaml:2]]
(use-package tuareg
  :mode (("\\.ml[ily]?$" . tuareg-mode)
         ("\\.topml$" . tuareg-mode))
  :init
  (progn
    (my/ocaml/init-opam)
    (add-hook 'tuareg-mode-hook 'company-mode)
    (add-hook 'tuareg-mode-hook 'flycheck-mode)
    (dolist (ext '(".cmo" ".cmx" ".cma" ".cmxa" ".cmi" ".cmxs" ".cmt"
                   ".cmti" ".annot"))
      (add-to-list 'completion-ignored-extensions ext))))
;; Ocaml:2 ends here

;; [[file:init.org::*Ocaml][Ocaml:3]]
(use-package merlin
  :delight (merlin-mode " ⚗")
  :hook (tuareg-mode . merlin-mode)
  :init
  (progn
    (add-to-list 'company-backends 'merlin-company-backend)))
;; Ocaml:3 ends here

;; [[file:init.org::*Ocaml][Ocaml:4]]
(use-package ocp-indent
  :hook (tuareg-mode . ocp-indent-caml-mode-setup))
;; Ocaml:4 ends here

;; [[file:init.org::*Ocaml][Ocaml:5]]
(with-eval-after-load 'smartparens
  (sp-local-pair 'tuareg-mode "'" nil :actions nil)
  (sp-local-pair 'tuareg-mode "`" nil :actions nil))
;; Ocaml:5 ends here

;; [[file:init.org::*Ocaml][Ocaml:6]]
(use-package utop
  :delight (utop-minor-mode " ū")
  :hook (tuareg-mode . utop-minor-mode)
  :config
  (progn
    (if (executable-find "opam")
        (setq utop-command "opam config exec -- utop -emacs")
      (message "warning: cannot find `opam' executable."))))
;; Ocaml:6 ends here

;; [[file:init.org::*Ocaml][Ocaml:7]]
(use-package flycheck-ocaml
  :after (flycheck merlin)
  :config
  (progn
    (setq merlin-error-after-save nil)
    (flycheck-ocaml-setup)))
;; Ocaml:7 ends here



;; Register a projectile project type for Dune.


;; [[file:init.org::*Ocaml][Ocaml:8]]
(use-package dune
  :mode ("\\(?:\\`\\|/\\)dune\\(?:\\.inc\\)?\\'" . dune-mode)
  :commands (dune-promote dune-runtest-and-promote))

(with-eval-after-load 'projectile
  (projectile-register-project-type
   'dune '("dune-project")
   :compile "dune build"
   :test "dune runtest"))
;; Ocaml:8 ends here

;; Go


;; [[file:init.org::*Go][Go:1]]
;; (use-package company-go)
(use-package go-mode
  :mode ("\\.go\\'". go-mode)
  :init
  (progn
    (defun my/go-mode-locals ()
      ;; (set (make-local-variable 'company-backends) '(company-go))
      ;; (company-mode 1)
      (setq tab-width 3))
    (add-hook 'go-mode-hook #'my/go-mode-locals)
    (add-hook 'go-mode-hook #'flycheck-mode)
    (add-hook 'before-save-hook #'gofmt-before-save)))
;; Go:1 ends here

;; CUDA


;; [[file:init.org::*CUDA][CUDA:1]]
(use-package cuda-mode
  :mode (("\\.cu\\'" . cuda-mode)
         ("\\.cuh\\'" . cuda-mode)))
;; CUDA:1 ends here

;; fish shell


;; [[file:init.org::*fish shell][fish shell:1]]
(use-package fish-mode
  :mode (("\\.fish\\'" . fish-mode)))
;; fish shell:1 ends here

;; Markdown


;; [[file:init.org::*Markdown][Markdown:1]]
(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
;; Markdown:1 ends here

;; Rust


;; [[file:init.org::*Rust][Rust:1]]
(use-package rustic
  :mode ("\\.rs\\'" . rustic-mode))
;; Rust:1 ends here

;; Lua


;; [[file:init.org::*Lua][Lua:1]]
(use-package lua-mode
  :commands (lua-mode)
  :mode ("\\.lua\\'" . lua-mode))
;; Lua:1 ends here

;; TODO TeX

;; [[https://github.com/raxod502/straight.el/issues/240][AUCTeX is a pain in the ass to install.]] Need to figure out how to delay-load this.


;; [[file:init.org::*TeX][TeX:1]]
(straight-use-package 'auctex)
(setq TeX-parse-self t) ; Enable parse on load.
(setq TeX-auto-save t) ; Enable parse on save.
(setq TeX-view-program-list
      '(("SumatraPDF"
         ("SumatraPDF.exe -reuse-instance"
          (mode-io-correlate " -forward-search \"%b\" %n")
          " %o")
         "SumatraPDF")))
(setq TeX-view-program-selection '((output-pdf "SumatraPDF")))
(setq TeX-source-correlate-mode t)
(setq TeX-source-correlate-method 'synctex)
;; TeX:1 ends here

;; Zig


;; [[file:init.org::*Zig][Zig:1]]
(use-package zig-mode
  :commands (zig-mode)
  :mode ("\\.zig\\'" . zig-mode))

(with-eval-after-load 'projectile
  (projectile-register-project-type
   'zig '("build.zig")
   :compile "zig build"
   :test "zig build"))
;; Zig:1 ends here

;; Emacs Server


;; [[file:init.org::*Emacs Server][Emacs Server:1]]
(server-start)
;; Emacs Server:1 ends here
