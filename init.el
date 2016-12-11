;;; package --- summary
;;; code:
;;; commentary:

(setq user-full-name "luming.lv")
(setq user-mail-address "Lv.luming0858@gmail.com")

(require 'package)
(add-to-list 'package-archives
	     ;; '("melpa" . "http://melpa.org/packages/")
	     ;; '("marmalade" . "http://marmalade-repo.org/packages"))
	     '("popkit" . "https://elpa.popkit.org/packages/"))
(package-initialize)

(setq initial-frame-alist '((width . 179) (height . 53))) ; Monaco-11
;; (setq initial-frame-alist '((width . 179) (height . 49))) ; Inconsolata-13

(require 'evil)
(evil-mode 1)
(setq evil-insert-state-cursor 'bar)

;; turn on soft wrapping mode for org mode
(add-hook 'org-mode-hook 'my:org-mode-truncate-lines)
(defun my:org-mode-truncate-lines()
  "Truncate lines in org mode."
  (setq truncate-lines nil))

(require 'org-bullets)
(add-hook 'org-mode-hook (lambda() (org-bullets-mode t)))

(setq org-hide-leading-stars t)
(setq org-ellipsis "⤵")

;; (load-theme 'solarized-dark t)
;; (load-theme 'color-theme-sanityinc-solarized-dark)

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)

(require 'yasnippet)
(yas-global-mode 1)


;;; C-c as general purpose escape key sequence.
;;;
(defun my:esc(prompt)
     "Functionality for escaping generally. 
Includes exiting Evil insert state and C-g binding.  PROMPT."
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
;; (load-theme 'zenburn t)
(when window-system
  (setq solarized-distinct-fringe-background t)
  (setq solarized-use-variable-pitch nil)
  (setq solarized-high-contrast-mode-line t)
  (setq solarized-height-minus-1 1)
  (setq solarized-height-plus-1 1)
  (setq solarized-height-plus-2 1)
  (setq solarized-height-plus-3 1)
  (setq solarized-height-plus-4 1)
  (load-theme 'solarized-dark t))

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
(electric-pair-mode 1)
(add-to-list 'electric-pair-pairs '(?\{ . ?\}))

;; (add-to-list 'default-frame-alist '(font . "Monaco-11"))
(add-to-list 'default-frame-alist '(font . "Inconsolata-13"))

(setq ns-pop-up-frames nil)


(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)


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
       (concat "javac " (file-name-nondirectory (buffer-file-name)))))))
  
(global-set-key (kbd "<f8>") 'my:javac-compile-currunt-buffer-file)


(defun my:java-exec-currunt-buffer-file()
  "exec current buffer's class file using 'java' command"
  (interactive)
  (shell-command
   (concat "java " (substring (file-name-nondirectory (buffer-file-name)) 0 -5))))

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

(setq tab-width 4)
(setq indent-tabs-mode nil)

(setq make-backup-files nil)

(global-set-key (kbd "s-[") 'text-scale-decrease)
(global-set-key (kbd "s-]") 'text-scale-increase)

(setq echo-keystrokes 0.1)

(setq use-dialog-box nil)

(setq my:task-org-dir "/Users/luminglv/org")
(setq my:task-org-file "/Users/luminglv/org/tasks.org")

(setq org-todo-keywords
      '((sequence "TODO(t!)" "INPROGRESS(p@)" "WAITING(w@)" "|" "DONE(d@)" "CANCEL(c@)")))
(setq org-todo-keyword-faces '(("INPROGRESS" . (:foreground "blue" :weight bold))
			       ("WAITING". (:foreground "dark goldenrod"))))

(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files (list my:task-org-dir))
(setq org-agenda-use-time-grid t)

(add-hook 'calendar-mode-hook
	  (lambda()
	    (local-set-key (kbd "C-{") 'calendar-backward-day)
	    (local-set-key (kbd "C-}") 'calendar-forward-day)))

(require 'cal-china-x)
(setq mark-holidays-in-calendar t)

(global-set-key (kbd "C-s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-s-<down>") 'shrink-window)
(global-set-key (kbd "C-s-<up>") 'enlarge-window)

(setq scroll-step 1)

;; (semantic-mode 1)

;; (defun my:add-semantic-to-autocomplete()
  ;; (add-to-list 'ac-sources 'ac-source-semantic))

;; (add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)

;; (setq org-log-done 'time)
;; (setq org-log-done 'note)

(setq org-agenda-span 15)

(defun my:org-agenda-init-evil-normal-state()
  (when (not (evil-normal-state-p))
      (evil-normal-state)))

(add-hook 'org-finalize-agenda-hook 'my:org-agenda-init-evil-normal-state)

(setq org-tag-alist '(("qunar" . ?q)
		      ("personal" . ?p)
		      ("habit" . ?h)
		      ("learning" . ?l)))

(defun my:task-org-file-go-to-last-line()
  (when (string= (buffer-file-name) my:task-org-file)
    (evil-goto-line)))

(add-hook 'find-file-hook 'my:task-org-file-go-to-last-line)

(defun my:org-agenda-ret-swith-to()
  (local-set-key (kbd "<return>") 'org-agenda-switch-to))

(add-hook 'org-finalize-agenda-hook 'my:org-agenda-ret-swith-to)

(require 'irony)
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(defun my:irony-mode-hook()
  "Irony Mode Hook."
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))

(add-hook 'irony-mode-hook 'my:irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(defvar my:jekyll-org-files-dir "~/org/jekyll/"
  "Org Files Dir for Jekyll Posts.")

(defun my:jekyll-org-dir-open(file-name)
    "open a jekyll-org file by name directly, create if not exists."
  (interactive "sWhich file to you want to open:")
  (let* ((jekyll-formatted-file-name (format "%s-%s.org" (format-time-string "%Y-%m-%d") file-name))
	 (jekyll-formatted-file-path (concat my:jekyll-org-files-dir jekyll-formatted-file-name)))
    (if (file-exists-p jekyll-formatted-file-path)
	(find-file jekyll-formatted-file-path)
      (progn
	(switch-to-buffer (get-buffer-create jekyll-formatted-file-name))
	(write-file jekyll-formatted-file-path)))))

(defun my:jekyll-org-dir-find()
  "find file in my:jekyll-org-files-dir directly"
  (interactive)
  (ido-find-file-in-dir my:jekyll-org-files-dir))

(defun my:misc-org-dir-find()
  "find file in ~/Files/llm/markdown dir directly"
  (interactive)
  (ido-find-file-in-dir "~/Files/llm/markdown_note"))

(setq org-default-notes-file my:task-org-file)

(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("t" "todo" entry (file my:task-org-file)
	 "* TODO %?  %^G\n  SCHEDULED: %^t\n" :empty-lines-before 1)))

(add-hook 'org-mode-hook
	  (lambda()
	    (local-set-key (kbd "C-c C-o") 'org-open-at-point)))

(require 'org-habit)
(add-to-list 'org-modules "org-habit")
(setq org-habit-show-habits-only-for-today t)
(setq org-habit-graph-column 40)

(setq org-log-into-drawer t)

(setq org-agenda-tags-column 80)

(elpy-enable)

(add-hook 'elpy-mode-hook
	  (lambda()
	    (define-key elpy-mode-map (kbd "M-.") nil)
	    (local-set-key (kbd "s-b") 'elpy-goto-definition)
	    (local-set-key (kbd "M-.") 'elpy-company-backend)))

(add-hook 'calendar-today-visible-hook 'calendar-mark-today)

(add-hook 'org-agenda-finalize-hook
	  (lambda() (delete-other-windows)))

(setq org-mobile-directory "~/Dropbox/MobileOrg")

(setq org-mobile-inbox-for-pull "~/org/from-mobile.org")

(add-hook 'after-save-hook
	  (lambda()
	    (when (string= buffer-file-name my:task-org-file)
	      (org-mobile-push))))

(add-hook 'after-init-hook 'org-mobile-pull)

(setq org-src-fontify-natively t)

(global-flycheck-mode)

(exec-path-from-shell-initialize)

(setq org-reveal-root "file:///Users/luminglv/reveal-js/reveal.js-3.3.0")

(setq-default flycheck-flake8-maximum-line-length 120)

(remove-hook 'elpy-modules 'elpy-module-flymake)

(defalias 'yes-or-no-p 'y-or-n-p)

(require 'company-irony)
(eval-after-load 'company
  '(add-to-list 'company-backends '(company-irony-c-headers company-irony)))

(add-hook 'after-init-hook 'global-company-mode)
(global-company-mode)
(setq company-backends (remove 'company-semantic company-backends))

(setq company-show-numbers t)
(setq company-idle-delay t)
(setq company-minimum-prefix-length 2)
(global-set-key (kbd "C-.") 'company-complete)

;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

(setq flycheck-c/c++-googlelint-executable "/usr/local/bin/cpplint")

(eval-after-load 'flycheck
  '(progn
     (require 'flycheck-google-cpplint)
     (flycheck-add-next-checker 'c/c++-clang
				'(warning . c/c++-googlelint))))

(setq my:last-mod-key "LAST_MOD")
(setq my:date-time-string-format "%Y-%m-%d %H:%M:%S")

(defun my:org-todo-state-change-update-lastmod()
  (org-entry-put
   (point)
   my:last-mod-key
   (format-time-string my:date-time-string-format)))

(add-hook 'org-after-todo-state-change-hook
	  'my:org-todo-state-change-update-lastmod)


(setq org-archive-location "~/org/archive.org::")

(defun my:auto-archive-tasks()
  "archive todo entries in my:task-org-file automatically.
   these conditions should be meet: 
   1. todo type is done 
   2. last_mod time is 15 days ago from current-time"

  (interactive)
  (when (string= (buffer-file-name) my:task-org-file)
    (let ((tree (org-element-parse-buffer 'headline)))
      (org-element-map tree 'headline
	(lambda(hl)
	  (let* ((entry-last-mod (org-element-property :LAST_MOD hl))
		(entry-todo-type (org-element-property :todo-type hl))
		(entry-id (org-element-property :ID hl))
		(entry-point (cdr (org-id-find-id-in-file entry-id my:task-org-file)))
		(entry-title (org-element-property :title hl)))
	    (when (and entry-last-mod
		       (string= entry-todo-type "done")
		       (time-less-p (date-to-time entry-last-mod)
				    (time-subtract (current-time) (days-to-time 15))))
	      (print entry-id)
	      (print entry-point)
	      (print entry-title)
	      (goto-char entry-point)
	      (org-archive-subtree)))))
      (save-buffer))))


(defun my:auto-add-id-to-task-entries()
  (when (string= (buffer-file-name) my:task-org-file)
    (org-map-entries 'org-id-get-create)
    (save-buffer)))


(add-hook 'find-file-hook 'my:auto-add-id-to-task-entries)
(add-hook 'find-file-hook 'my:auto-archive-tasks)

(require 'org-id)

(add-hook 'org-capture-before-finalize-hook
	  (lambda()
	    (org-set-property
	     my:last-mod-key
	     (format-time-string my:date-time-string-format))))


(provide 'init)
;;; init.el ends here

