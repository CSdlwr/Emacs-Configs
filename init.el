

;(set-frame-position (selected-frame) 0 0)
;(set-frame-width (selected-frame) 110)
;(set-frame-height (selected-frame) 33)

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/")
	     '("marmalade" . "http://marmalade-repo.org/packages"))
(package-initialize)

(require 'evil)
(evil-mode 1)
(setq evil-insert-state-cursor 'bar)

;; turn on soft wrapping mode for org mode
(add-hook 'org-mode-hook 'org-mode-truncate-lines)
(defun org-mode-truncate-lines ()
  (setq truncate-lines nil))

(require 'org-bullets)
(add-hook 'org-mode-hook
	  (lambda ()
	    (org-bullets-mode t)))
(setq org-hide-leading-stars t)

;; (load-theme 'solarized-dark t)
;; (load-theme 'color-theme-sanityinc-solarized-dark)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)


;;; C-c as general purpose escape key sequence.
;;;
(defun my-esc (prompt)
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

(require 'powerline-evil)
(powerline-evil-center-color-theme)
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
