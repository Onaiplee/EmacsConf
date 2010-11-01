(require 'icicles)
(require 'fuzzy-match)

(setq icicle-expand-input-to-common-match-flag t)
(setq icicle-fuzzy-completion-flag nil)
(setq icicle-search-replace-whole-candidate-flag nil)
(setq icicle-incremental-completion-flag t)

;; Make competion not case-sensitive
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)

;; Key bindings
(add-hook 'icicle-mode-hook 'bind-my-icicles-keys)
(defun bind-my-icicles-keys ()
  "Replace some default Icicles minibuffer bindings with others."
  (dolist (map (append (list minibuffer-local-completion-map
                             minibuffer-local-must-match-map)
                       (and (fboundp 'minibuffer-local-filename-completion-map)
                            (list minibuffer-local-filename-completion-map))))
    (when icicle-mode
      (define-key map (kbd "<tab>") 'icicle-apropos-complete)
      (define-key map (kbd "<backtab>") 'icicle-prefix-complete)
      (define-key map (kbd "C-s") 'icicle-next-candidate-per-mode)
      (define-key map (kbd "C-r") 'icicle-previous-candidate-per-mode)
      (define-key map (kbd "C-f") 'icicle-toggle-fuzzy-completion)
      (define-key map (kbd "C-k") 'icicle-delete-candidate-object)
      (define-key map (kbd "C-n") 'icicle-toggle-incremental-completion)
)))

(setq icicle-top-level-key-bindings
      '(([pause]
         icicle-switch-to/from-minibuffer t)
        ("`" icicle-search-generic t)
        ("$" icicle-search-word t)
        ("^" icicle-search-keywords t)
        ("'" icicle-occur t)
        ("=" icicle-imenu t)
        ("\"" icicle-search-text-property t)
        ("'" icicle-complete-thesaurus-entry t)
        ([24 134217829]
        icicle-execute-named-keyboard-macro t)
        (" " icicle-command-abbrev t)
        ("5o" icicle-select-frame t)
        ("" icicle-describe-option-of-type t)
        ([S-f4] icicle-kmacro t)
        (abort-recursive-edit icicle-abort-recursive-edit t)
        (minibuffer-keyboard-quit icicle-abort-recursive-edit
        (fboundp 'minibuffer-keyboard-quit))
        (execute-extended-command icicle-execute-extended-command t)
        (switch-to-buffer icicle-buffer t)
        (switch-to-buffer-other-window icicle-buffer-other-window t)
        (find-file icicle-file t)
        (find-file-other-window icicle-file-other-window t)
        (pop-tag-mark icicle-pop-tag-mark
        (fboundp 'command-remapping))
        (find-tag icicle-find-tag
        (fboundp 'command-remapping))
        (eval-expression icicle-pp-eval-expression
        (fboundp 'command-remapping))
        (pp-eval-expression icicle-pp-eval-expression
        (fboundp 'command-remapping))
        (find-tag-other-window icicle-find-first-tag-other-window t)
        (kill-buffer icicle-kill-buffer t)
        (kill-buffer-and-its-windows icicle-kill-buffer t)
        (delete-window icicle-delete-window t)
        (delete-windows-for icicle-delete-window t)
        (other-window-or-frame icicle-other-window-or-frame t)
        (other-window icicle-other-window-or-frame t)
        (exchange-point-and-mark icicle-exchange-point-and-mark t)
        (where-is icicle-where-is t)
        (yank icicle-yank-insert t)
        (set-mark-command icicle-goto-marker-or-set-mark-command t)
        (pop-global-mark icicle-goto-global-marker-or-pop-global-mark t)
        ([27 134217848]
        lacarte-execute-menu-command
        (fboundp 'lacarte-execute-menu-command))
        ([134217824]
        lacarte-execute-menu-command
        (fboundp 'lacarte-execute-menu-command))
        ([f10]
        lacarte-execute-menu-command
        (fboundp 'lacarte-execute-menu-command)))
)

(icicle-mode t)
