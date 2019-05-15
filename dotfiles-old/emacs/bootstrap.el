;; bootstrap.el
;; Use this as init.el -- it will automatically replace itself on first run.

(require 'org)
(find-file (concat user-emacs-directory "init.org"))
(org-babel-tangle)
(load-file (concat user-emacs-directory "init.el"))
(byte-compile-file (concat user-emacs-directory "init.el"))
