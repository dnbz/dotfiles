
;; config.el -*- lexical-binding: t; -*-
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Global settings

;; (if (string-equal (getenv "SYSTEM") "desktop-1")
;;     (progn
;;       (setq my-font-size 16)
;;       (setq my-variable-font-size 18)
;;       )
;;   (progn
;;     (setq my-font-size 28)
;;     (setq my-variable-font-size 32)
;;     )
;;   )

(setq
 ;; doom-font (font-spec :family "IBM Plex Mono" :size 16 )
 ;; doom-font (font-spec :family "Fira Code" :size 17 )
 ;; doom-font (font-spec :family "Noto Sans Mono" :size 17 )
 ;; doom-font (font-spec :family "Ubuntu Mono" :size 17 )
 doom-font (font-spec :family "JetBrains Mono" :size 15 )
 doom-localleader-key ","
 org-directory "~/org/"
 ;; doom-font (font-spec :family "Fira Code" :size 15)
 doom-variable-pitch-font (font-spec :family "BlexMono Nerd Font Mono" :size 16 )
 ;;doom-variable-pitch-font (font-spec :family "JetBrains Mono" :size 36 )
 ;; doom-variable-pitch-font (font-spec :family "Linux Biolinum O" :size 18)
 ;; doom-variable-pitch-font (font-spec :family "Linux Libertine O" :size 20)

 ;; doom-theme 'doom-badger
 ;; doom-theme 'doom-gruvbox-light
 doom-theme 'doom-material-dark
 ;; doom-theme 'doom-solarized-light
 ;; doom-theme 'doom-zenburn
 ;;
 ;; disable hover over popups with lsp
 lsp-ui-doc-show-with-cursor nil
 lsp-ui-doc-show-with-mouse nil
 lsp-ui-sideline-enable nil
 lsp-ui-sideline-show-hover nil
 lsp-eldoc-enable-hover nil

 projectile-known-projects-file (concat doom-private-dir "projectile.projects")
 projectile-ignored-projects '("~/" "/tmp" "~/.emacs.d/")
 display-time-mode t
 scroll-margin 5
 tab-width 4
 display-line-numbers-type t)

(map! :map global-map
      :desc "Previous workspace" "M-[" #'+workspace:switch-previous
      :desc "Next workspace" "M-]" #'+workspace:switch-next
      )

(defun align-to-equals (begin end)
  "Align region to equal signs"
  (interactive "r")
  (align-regexp begin end "\\(\\s-*\\)=" 1 1 ))

(defun align-to-colon (begin end)
  "Align region to colon (:) signs"
  (interactive "r")
  (align-regexp begin end
                (rx ":" (group (zero-or-more (syntax whitespace))) ) 1 1 ))

(map! :map evil-visual-state-map
      :prefix "ga"
      :desc "Align to equals" ":" #'align-to-equals
      :desc "Align to colon" "=" #'align-to-colon
      )

;; Org
(after! org
  (set-face-attribute 'org-level-1 nil :height 1.25)
  (set-face-attribute 'org-level-2 nil :height 1.15)
  (set-face-attribute 'org-level-3 nil :height 1.1)
  (set-face-attribute 'org-level-4 nil :height 1.05)
  (set-face-attribute 'org-level-5 nil :height 1.0)
  (set-face-attribute 'org-level-6 nil :height 1.0)
  (set-face-attribute 'org-document-title nil :height 1.75 :weight 'bold)
                                        ; Start lists with a dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "BUY(b)"
           "LOOP(r)"
           "WAIT(w)"
           "HOLD(h)"
           "IDEA(i)"
           "|" "DONE(d)")
          (sequence
           "[](T)"
           "[-](S)"
           "[?](W)"
           "|" "[X](D)"))
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("IDEA" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)))
  )

(defun org-extract-link ()
  "Extract link at point and put it on the killring"
  (interactive)
  (when (org-in-regexp org-bracket-link-regexp 1)
    (let ((org-extracted-link (->
                               1
                               org-match-string-no-properties
                               org-link-unescape)))
      (kill-new org-extracted-link)
      (message "Copied \"%s\"." org-extracted-link))))

;; Keybindings
(map! :after org
      (:localleader :map org-mode-map
       :desc "Copy link at point" :n "C" #'org-extract-link)
      :n "M-j" #'org-metadown
      :n "M-h" #'org-metaup
      )

;; Disable completion for org
(defun zz/adjust-org-company-backends ()
  (remove-hook 'after-change-major-mode-hook '+company-init-backends-h)
  (setq-local company-backends nil))

(add-hook! org-mode (zz/adjust-org-company-backends))
(add-hook 'org-mode-hook 'org-appear-mode)
(add-hook 'org-mode-hook (lambda () (flycheck-mode -1)))
(add-hook 'org-mode-hook #'doom-disable-line-numbers-h)

(use-package! mixed-pitch
  :config
  (setq mixed-pitch-set-height t)
  (set-face-attribute 'variable-pitch nil :height 1.6)
  :hook
  ((org-mode markdown-mode) . mixed-pitch-mode)
  ;; (text-mode . mixed-pitch-mode)
  )


;; Elfeed
(after! elfeed
  (setq
   elfeed-search-filter "@1-month-ago +unread"
   elfeed-search-face-alist '(
                              (podcast elfeed-log-warn-level-face)
                              (video elfeed-log-info-level-face)
                              (news elfeed-search-date-face)
                              (unread elfeed-search-unread-title-face))
   ))

(map! :after elfeed
      (:map elfeed-search-mode-map
       :desc "Reload" :n "R" #'elfeed-update
       ))

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)
(add-hook 'elfeed-show-mode-hook 'visual-fill-column-mode)
(add-hook 'elfeed-show-mode-hook
          (lambda ()
            (setq
             shr-width 100
             visual-fill-column-center-text t
             visual-fill-column-width 125)))


(setq +format-on-save-enabled-modes
      '(not php-mode  ; elisp's mechanisms are good enough
        latex-mode
        python-mode
        js-mode
        typescript-mode
        ))

(setq-hook! 'php-mode-hook +format-with-lsp nil)
(setq-hook! 'python-mode-hook +format-with-lsp nil)
(setq-hook! 'js-mode-hook +format-with-lsp nil)

(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")

(setq-hook! 'js-mode-hook
  +format-with-lsp nil
  tab-width 2
  )

;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
