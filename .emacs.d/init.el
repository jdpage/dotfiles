;;; -*- lexical-binding: t -*-
;;; THIS IS A GENERATED FILE; see init.org

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

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file t)

(defun my/load-local-init ()
  (let ((local-file (concat user-emacs-directory "/local-" (system-name) ".el")))
    (message local-file)
    (when (file-exists-p local-file)
      (load-file local-file))))

(add-hook 'after-init-hook 'my/load-local-init)

(defconst *my/is-macos*
  (memq window-system '(mac ns))
  "True if Emacs is running under macOS")

(defconst *my/is-gnu-like*
  (or (string= "cygwin" system-type)
      (string= "windows-nt" system-type)
      (string-prefix-p "gnu" (symbol-name system-type)))
  "True if we expect GNU-like coreutils")

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(require 'use-package)
(use-package auto-compile
  :config (auto-compile-on-load-mode))
(setq load-prefer-newer t)

(use-package dash :config (dash-enable-font-lock))
(use-package delight)

(use-package exec-path-from-shell
  :if *my/is-macos*
  :config
  (exec-path-from-shell-initialize))

(when (not *my/is-gnu-like*)
  (setq dired-use-ls-dired nil))

(setq my-backup-directory (concat user-emacs-directory "backups"))
(when (not (file-exists-p my-backup-directory))
  (make-directory my-backup-directory))
(setq backup-directory-alist `(("." . ,my-backup-directory)))

(setq backup-by-copying t)    ; this is a bit safer
(setq version-control t)      ; numbered backups
(setq delete-old-versions t)  ; manage excess backups
(setq kept-old-versions 6)
(setq kept-new-versions 9)

(setq delete-by-moving-to-trash t)

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

(setq-default show-trailing-whitespace t)
(setq inhibit-startup-message t)
(setq global-linum-mode nil)  ; maybe?

(add-to-list 'default-frame-alist
             '(font . "Fantasque Sans Mono-10"))

(tool-bar-mode 0)      ; no toolbars
(scroll-bar-mode 0)    ; no scrollbars
(blink-cursor-mode 0)  ; no blinking cursor
(show-paren-mode 1)
(global-prettify-symbols-mode 0)

(use-package better-defaults)

(setq default-input-method "TeX")
(setq initial-scratch-message nil)
(setq sentence-end-double-space nil)
(setq-default fill-column 80)
(setq-default truncate-lines nil)  ; visual wrap
(setq-default auto-fill-function 'do-auto-fill)
(fset 'yes-or-no-p 'y-or-n-p)  ; laziness enhancer

(use-package emacs
  :delight
  (auto-fill-function " ⭤"))

(delete-selection-mode 1)
(global-auto-revert-mode 1)

(set-language-environment "UTF-8")

(use-package smartparens
  :config
  (require 'smartparens-config))

(use-package company
  :config
  (global-company-mode))

(use-package flycheck
  :delight (flycheck-mode " 👁")
  :commands flycheck-mode)

(use-package which-key
  :delight which-key-mode
  :config (which-key-mode 1))

(use-package powerline
  :config (powerline-default-theme))

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

(setq my-light-theme 'gruvbox-light-soft)
(setq my-dark-theme 'gruvbox-dark-soft)
(setq my-initial-theme my-dark-theme)

(defun my/toggle-theme ()
  (interactive)

  (let ((is-dark (seq-contains custom-enabled-themes my-dark-theme)))
    (dolist (theme custom-enabled-themes)
      (disable-theme theme))
    (load-theme (if is-dark my-light-theme my-dark-theme) t)))

(use-package gruvbox-theme
  :if window-system
  :demand t
  :bind ("C-x T t" . my/toggle-theme)
  :config
  (load-theme my-initial-theme t))

(use-package undo-tree
  :delight undo-tree-mode
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-visualizer-timestamps t)
    (setq undo-tree-visualizer-diff t)))

(use-package ace-window
  :bind ("M-o" . ace-window))

(use-package evil
  :config
  (evil-mode 1))

(setq my-project-type-glyph-alist
   '((nil . "Ø")
     (generic . "*")
     (cmake . "▲")
     (dune . "🏜")))

(defun my/project-type-glyph ()
  (let ((type (projectile-project-type)))
    (cdr
      (or (assoc type my-project-type-glyph-alist)
          (cons type type)))))

(use-package projectile
  :demand
  :after (helm)
  :delight (projectile-mode
            (:eval (format " 🚀:%s" (my/project-type-glyph))))
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (progn
    (projectile-mode 1)
    (projectile-discover-projects-in-search-path)
    (setq projectile-completion-system 'helm)))

(use-package helm
  :delight helm-mode
  :demand t
  :init
  (progn
    (setq helm-mode-fuzzy-match t)
    (setq helm-completion-in-region-fuzzy-match t)
    (setq helm-always-two-windows nil)
    (setq helm-display-buffer-default-height 23)
    (setq helm-default-display-buffer-functions
          '(display-buffer-in-side-window)))
  :config
  (progn
    (require 'helm-config)
    (helm-mode 1)
    (helm-adaptive-mode 1))
  :bind (("M-x" . helm-M-x)
         ("C-x r b" . helm-filtered-bookmarks)
         ("C-x C-f" . helm-find-files)))
(ido-mode 0)

(use-package helm-projectile
  :after (helm projectile)
  :config (helm-projectile-on))

(use-package treemacs
  :config
  (progn
    (treemacs-git-mode 'deferred)
    (treemacs-filewatch-mode 1)
    (define-key treemacs-mode-map [mouse-1]
      #'treemacs-single-click-expand-action)))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

(use-package treemacs-evil
  :after (treemacs evil))

(defun my/treemacs-command (arg)
  (interactive "P")
  (if (> (prefix-numeric-value arg) 1)
      (treemacs)
    (treemacs-select-window)))

(global-set-key (kbd "C-x t") 'my/treemacs-command)

(add-hook 'my/toggle-face-height-hook
          #'(lambda ()
              (treemacs-resize-icons
               (if (> (my/current-default-face-height) 80) 22 11))))

(treemacs-select-window)

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

(use-package htmlize)

(use-package org-d20
  :commands org-d20-mode)

(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (progn
    (add-hook 'magit-mode-hook #'(lambda () (origami-mode 0)))))

(use-package evil-magit
  :after (evil magit))

(use-package git-gutter-fringe
  :delight git-gutter-mode
  :config (global-git-gutter-mode 1))

(use-package matlab-mode
  :mode "\\.m\\'"
  :init
  (progn
    (setq matlab-indent-function t)  ; TODO figure out what this does
    (setq matlab-shell-command "/usr/local/bin/matlab")))

(use-package elpy
  :delight (elpy-mode " 🐍")
  :config
  (progn
    (elpy-enable)

    ;; replace flymake with flycheck
    (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
    (add-hook 'elpy-mode-hook 'flycheck-mode)))

(use-package blacken
  :delight (blacken-mode " 🏴")
  :hook (elpy-mode . blacken-mode))

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

(use-package merlin
  :delight (merlin-mode " ⚗")
  :hook (tuareg-mode . merlin-mode)
  :init
  (progn
    (add-to-list 'company-backends 'merlin-company-backend)))

(use-package ocp-indent
  :hook (tuareg-mode . ocp-indent-caml-mode-setup))

(with-eval-after-load 'smartparens
  (sp-local-pair 'tuareg-mode "'" nil :actions nil)
  (sp-local-pair 'tuareg-mode "`" nil :actions nil))

(use-package utop
  :delight (utop-minor-mode " ⩂")
  :hook (tuareg-mode . utop-minor-mode)
  :config
  (progn
    (if (executable-find "opam")
        (setq utop-command "opam config exec -- utop -emacs")
      (message "warning: cannot find `opam' executable."))))

(use-package flycheck-ocaml
  :after (flycheck merlin)
  :config
  (progn
    (setq merlin-error-after-save nil)
    (flycheck-ocaml-setup)))

(use-package dune)

(with-eval-after-load 'projectile
  (projectile-register-project-type
   'dune '("dune-project")
   :compile "dune build"
   :test "dune runtest"))

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

(use-package cuda-mode
  :mode (("\\.cu\\'" . cuda-mode)
         ("\\.cuh\\'" . cuda-mode)))

(use-package fish-mode
  :mode (("\\.fish\\'" . fish-mode)))
