(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-save-default nil)
 '(c-syntactic-indentation t)
 '(c-tab-always-indent t)
 '(canlock-password "8225634b21d31eaa687444f4d1e696bab28e0b26")
 '(case-fold-search t)
 '(column-number-mode t)
 '(display-time-mode t)
 '(fringe-mode (quote (16 . 0)) nil (fringe))
 '(global-font-lock-mode t nil (font-lock))
 '(indicate-buffer-boundaries (quote ((t . left) (top . left) (bottom . left) (up . left) (down . left))))
 '(safe-local-variable-values (quote ((todo-categories "daily"))))
 '(show-paren-mode t)
 '(tab-width 4)
 '(transient-mark-mode t))

;; =============== Coding and Language ===============>
(set-selection-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(setq current-language-environment "utf-8")
(setq locale-language-names 
      (cons '("zh_CN.UTF-8" "UTF-8" utf-8) locale-language-names))

;; Fix the width of Chinese marks.
(let ((l '(chinese-gb2312
           gb18030-2-byte
           gb18030-4-byte-bmp
           gb18030-4-byte-ext-1
           gb18030-4-byte-ext-2
           gb18030-4-byte-smp)))
  (dolist (elt l)
    (map-charset-chars #'modify-category-entry elt ?|)
    (map-charset-chars
     (lambda (range ignore) 
       (set-char-table-range char-width-table range 2))
     elt)))

;;=========== Some basic settings ==============================>
(setq user-full-name "Corsair")
(setq user-mail-address "chris.corsair@gmail.com")
(setq default-major-mode 'text-mode)
(setq default-tab-width 4)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)
(setq column-number-mode t)
(setq kill-ring-max 255)
(setq next-screen-context-lines 5)
(setq display-time-day-and-date t)
(setq sentence-end "\\([。！？；]\\|……\\|[.?!;][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*")
(setq sentence-end-double-space t)
(setq scroll-margin 4
      scroll-conservatively 1000) ;;continuous scrolling
(setq dired-recursive-copies 'top)
(setq dired-recursive-deletes 'top)
(setq adaptive-fill-regexp "[ \t]+\\|[ \t]*\\([0-9]+\\.\\|\\*+\\)[ \t]*")
(setq tab-stop-list 
      '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 96 100 104 108 112 116 120))
;; let the delete key delete foreward
(if window-system (normal-erase-is-backspace-mode 1))

;; Display time information in modeline.
(setq display-time-format "%Y-%m-%d %A %I:%M") 
(display-time)

(add-hook 'text-mode-hook
		  (lambda () (auto-fill-mode t)))

(setq require-final-newline t)

;;time stamp
(add-hook 'write-file-hooks 'time-stamp)
(setq time-stamp-active t)
(setq time-stamp-format "%:u %04y-%02m-%02d %02H:%02M:%02S")
(setq time-stamp-end: "\n")

;;所有的 yes or no 全都用 y or n 代替 :-)
(fset 'yes-or-no-p 'y-or-n-p)
;; Turn on auto save function
(setq auto-save-default t)
;; Enable Narrow
(put 'narrow-to-region 'disabled nil)
;; 鼠标要挡住正在打的字时自动移开
(mouse-avoidance-mode 'animate)

;; Replace selected text when typing
(delete-selection-mode t)

(setq default-input-method "TeX")

;; Use external `ls' rather than `ls-lisp'.
(setq ls-lisp-use-insert-directory-program t)
;; No sound alarm!
(setq visible-bell t)

;; printer settings
(setq printer-name "PDFPrinter")
(setq ps-font-size '(7 . 8))
(setq ps-multibyte-buffer 'bdf-font-except-latin)
(setq ps-paper-type 'a4)
(setq ps-number-of-columns 1)

;; Scheme program
(setq scheme-program-name "mzscheme")

;; Spell check
(setq-default ispell-program-name "aspell")
(add-hook 'text-mode-hook 'flyspell-mode)
