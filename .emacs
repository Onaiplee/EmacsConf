;; ================= add load path ====================>
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

;; ================= Coding and Language ==============>

;; ================= Some basic settings ==============>
(setq user-full-name "Shaobi Li")
(setq user-mail-address "shaobili@gmail.com")
(setq mail-user-agent 'message-user-agent)
(setq default-major-mode 'text-mode)
(setq default-tab-width 4)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)
(setq column-number-mode t)
(setq kill-ring-max 255)
(setq frame-title-format "Shaobi's GNU Emacs23 <%b>")
(setq tab-stop-list
      '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 96 100 104 108 112 116 120))
(fset 'yes-or-no-p 'y-or-n-p)
(setq auto-save-default t)
(put 'narrow-to-region 'disabled nil)
;; 鼠标要挡住正在打的字时自动移开
(mouse-avoidance-mode 'animate)

;; ================= Programming Langurage Option =====================>
;; C Indention
(add-hook 'c-mode-common-hook
		  (lambda () (c-toggle-auto-hungry-state 1)))
;; CC Indention
(defconst my-c-style
  '((c-tab-always-indent        . t)
    (c-comment-only-line-offset . 0)
    (c-hanging-braces-alist     . ((substatement-open after)
                                   (brace-list-open)))
    (c-hanging-colons-alist     . ((member-init-intro before)
                                   (inher-intro)
                                   (case-label after)
                                   (label after)
                                   (access-label after)))
    (c-cleanup-list             . (scope-operator
                                   empty-defun-braces
                                   defun-close-semi))
    (c-offsets-alist            . ((arglist-close . c-lineup-arglist)
                                   (substatement-open . 0)
                                   (case-label        . 4)
                                   (block-open        . 0)
                                   (knr-argdecl-intro . -)))
    (c-echo-syntactic-information-p . t)
    )
  "My C Programming Style")
;; offset customizations not in my-c-style
(setq c-offsets-alist '((member-init-intro . ++)))
;; Customizations for all modes in CC Mode.
(defun my-c-mode-common-hook ()
  ;; add my personal style and set it for the current buffer
  (c-add-style "PERSONAL" my-c-style t)
  ;; we like auto-newline and hungry-delete
  (c-toggle-auto-hungry-state 1)
  ;; key bindings for all supported languages.  We can put these in
  ;; c-mode-base-map because c-mode-map, c++-mode-map, objc-mode-map,
  ;; java-mode-map, idl-mode-map, and pike-mode-map inherit from it.
  (define-key c-mode-base-map "\C-m" 'c-context-line-break)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;; Whether the indentation should be controlled by the syntactic context.
(setq c-syntactic-indentation t)

;; Python + Flymake
(when (load "flymake" t)
  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "pyflakes" (list local-file))))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init)))

(add-hook 'python-mode-hook 'flymake-mode)

;; Python + ElDoc
(add-hook 'python-mode-hook
          (lambda () (eldoc-mode 1)) t)
(defun my-python-documentation (w)
  "Launch PyDOC on the Word at Point"
  (interactive
   (list (let* ((word (thing-at-point 'word))
                (input (read-string
                        (format "pydoc entry%s: "
                                (if (not word) "" (format " (default %s)" word))))))
           (if (string= input "")
               (if (not word) (error "No pydoc args given")
                 word) ;sinon word
             input)))) ;sinon input
  (shell-command (concat py-python-command " -c \"from pydoc import help;help(\'" w "\')\"") "*PYDOCS*")
  (view-buffer-other-window "*PYDOCS*" t 'kill-buffer-and-window))

;; Whitespace mode
(require 'whitespace)
(setq-default whitespace-style
              '(tabs trailing lines space-before-tab))
(setq-default whitespace-active-style
              '(tabs trailing lines space-before-tab))
(add-hook 'emacs-lisp-mode-hook 'whitespace-mode)
(add-hook 'cc-mode-hook 'whitespace-mode)
(add-hook 'c-mode-hook 'whitespace-mode)
(add-hook 'c++-mode-hook 'whitespace-mode)
(add-hook 'python-mode-hook 'whitespace-mode)

;; Display line number
(require 'linum)
(global-linum-mode t)
(defun toggle-linum () ; Toggle line numbering
  (interactive)
  (if linum-mode (linum-mode nil)
    (linum-mode t)))

;; Hide show mode (from emacswiki)
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
             (1+ (current-column))))))
(defun toggle-hiding (column)
  (interactive "P")
  (if hs-minor-mode
      (if (condition-case nil
              (hs-toggle-hiding)
            (error t))
          (hs-show-all))
    (toggle-selective-display column)))

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)

;; Ocaml
(setq auto-mode-alist
          (cons '("\\.ml[iyl]?$" .  caml-mode) auto-mode-alist))

;; you should probably comment the next line or replace ~remy by another path 
(setq load-path (cons "~remy/emacs/" load-path))

(autoload 'caml-mode "ocaml" (interactive)
  "Major mode for editing Caml code." t)
(autoload 'camldebug "camldebug" (interactive) "Debug caml mode")
;; Yacc & Bison
;;(add-to-set! auto-mode-alist '("\\.y$" . bison-mode))
(setq auto-mode-alist
          (cons '("\\.y$" .  bison-mode) auto-mode-alist))
(autoload 'bison-mode "bison-mode" (interactive)
  "Major mode for editing bison or yacc code." t)

(autoload 'flex-mode "flex-mode")
;;(add-to-set! auto-mode-alist '("\\.l$" . flex-mode))

;; haskell-mode
(load "~/.emacs.d/haskell-mode/haskell-site-file")
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
;;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
