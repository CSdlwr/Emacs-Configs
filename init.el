

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/")
	     '("marmalade" . "http://marmalade-repo.org/packages"))
(package-initialize)

(setq initial-frame-alist
      '((width . 179)
	(height . 46)
	))

(require 'evil)
(evil-mode 1)
(setq evil-insert-state-cursor 'bar)

;; turn on soft wrapping mode for org mode
(add-hook 'org-mode-hook 'my:org-mode-truncate-lines)
(defun my:org-mode-truncate-lines ()
  (setq truncate-lines nil))

(require 'org-bullets)
(add-hook 'org-mode-hook
	  (lambda ()
	    (org-bullets-mode t)))
(setq org-hide-leading-stars t)
;; (setq org-ellipsis "⤵")

;; (load-theme 'solarized-dark t)
;; (load-theme 'color-theme-sanityinc-solarized-dark)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)


;;; C-c as general purpose escape key sequence.
;;;
(defun my:esc (prompt)
     "Functionality for escaping generally.  Includes exiting Evil insert state and C-g binding. "
     (cond
      ;; If we're in one of the Evil states that defines [escape] key, return [escape] so as
      ;; Key Lookup will use it.
      ((or (evil-insert-state-p) (evil-normal-state-p) (evil-replace-state-p) (evil-visual-state-p)) [escape])
      ;; This is the best way I could infer for now to have C-c work during evil-read-key.
      ;; Note: As long as I return [escape] in normal-state, I don't need this.
      ;;((eq overriding-terminal-local-map evil-read-key-map) (keyboard-quit) (kbd ""))
      (t (kbd "C-g"))))

;; (define-key key-translation-map (kbd "C-c") 'my-esc)
;; Works around the fact that Evil uses read-event directly when in operator state, which
;; doesn't use the key-translation-map.
;; (define-key evil-operator-state-map (kbd "C-c") 'keyboard-quit)
;; Not sure what behavior this changes, but might as well set it, seeing the Elisp manual's
;; documentation of it.
;; (set-quit-char "C-c")


;(require 'color-theme)
;(color-theme-initialize)
;(color-theme-classic)
(load-theme 'zenburn t)

(menu-bar-mode -1)

(tool-bar-mode -1)

(scroll-bar-mode -1)

(blink-cursor-mode -1)

(column-number-mode)

(global-linum-mode 1)

(global-hl-line-mode 1)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq ido-separator "\n")

(require 'powerline-evil)
(powerline-evil-center-color-theme)
(setq powerline-default-separator 'wave)

;(powerline-evil-vim-theme)
;(powerline-evil-vim-color-theme)
;(powerline-center-theme)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
;(global-set-key (kbd "M-x") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(show-paren-mode t)
(require 'autopair)
(autopair-global-mode)

(add-to-list 'default-frame-alist '(font . "Monaco-12"))

(setq ns-pop-up-frames nil)

(defun my:ac-c-header-init()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers))

;; (add-hook 'c++-mode-hook 'my:ac-c-header-init)
;; (add-hook 'c-mode-hook 'my:ac-c-header-init)

(defun my:flymake-google-init()
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load))

;; (add-hook 'c++-mode-hook 'my:flymake-google-init)
;; (add-hook 'c-mode-hook 'my:flymake-google-init)

;; (require 'google-c-style)
;; (add-hook 'c-mode-common-hook 'google-set-c-style)
;; (add-hook 'c-mode-common-hook 'google-make-newline-indent)


(add-to-list 'load-path "~/.emacs.d/auto-java-complete")
(require 'ajc-java-complete-config)
(add-hook 'java-mode-hook 'ajc-java-complete-mode)
;; (add-hook 'find-file-hook 'ajc-4-jsp-find-file-hook)


(defun my:comment-dwim-line(&optional arg)
  "replacement for the comment-dwin command.
   if no region is selected and current line is not blank 
   and the point is not at the end of the line, then comment the current line.
   replaces default behaviour of comment-dwin, when inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (progn
	(comment-or-uncomment-region (line-beginning-position) (line-end-position))
	(next-line))
    (comment-dwim arg)))

(global-set-key (kbd "s-/") 'my:comment-dwim-line)


(defun my:javac-compile-currunt-buffer-file()
  "compile current buffer's file using 'javac' command 
   if it's a java source file(*.java)"
  (interactive)
  (if (not (string-suffix-p ".java" (buffer-file-name)))
      (message "not a java source file!")
    (progn
      (save-buffer)
      (shell-command
       (concat "javac " (file-name-nondirectory (buffer-file-name))))
      )))
  
(global-set-key (kbd "<f8>") 'my:javac-compile-currunt-buffer-file)


(defun my:java-exec-currunt-buffer-file()
  "exec current buffer's class file using 'java' command"
  (interactive)
  (shell-command
   (concat "java " (substring (file-name-nondirectory (buffer-file-name)) 0 -5))
   ))

(global-set-key (kbd "<f9>") 'my:java-exec-currunt-buffer-file)


(global-set-key (kbd "M-p") 'ace-window)

(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))

(setq aw-dispatch-always t)

(defvar aw-dispatch-alist
'((?x aw-delete-window " Ace - Delete Window")
    (?m aw-swap-window " Ace - Swap Window")
    (?n aw-flip-window)
    (?v aw-split-window-vert " Ace - Split Vert Window")
    (?b aw-split-window-horz " Ace - Split Horz Window")
    (?i delete-other-windows " Ace - Maximize Window")
    (?o delete-other-windows))
"List of actions for `aw-dispatch-default'.")
