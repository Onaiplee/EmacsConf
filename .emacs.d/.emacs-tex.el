;; AucTEX
(load "auctex.el" nil t t)
;; (load "~/.emacs.d/auctex/preview/preview-latex.el" nil t t)
(setq TeX-parse-self t)                 ; Enable parse on load.
(setq TeX-auto-save t)                  ; Enable parse on save.
(setq-default TeX-master nil)
; make PDF by default (can toggle with C-c C-t C-p
(add-hook 'TeX-mode-hook '(lambda () (TeX-PDF-mode 1)))
;; (require 'latex)			; defines LaTeX-math-mode
;; (add-hook 'TeX-mode-hook 'LaTeX-math-mode)
; Emacs help for \label, \ref, \cite.  Normally used only with
; LaTeX-mode but also useful with plain TeX + eplain and with ConTeXt, so:
(setq reftex-plug-into-AUCTeX t)
(add-hook 'TeX-mode-hook 'reftex-mode)

(defun start-context-math ()
  (interactive)
  (let* ((start (max (point-min) (- (point) 1)))
	 (stop  (min (point-max) (+ (point) 1))))
    ; if in the middle of a $$, turn inline math into context display math
    (if (equal "$$" (buffer-substring-no-properties start stop))
	(progn
	  (delete-region start stop)	;get rid of the $$
	  ; delete preceding spaces, if any
	  (while (and (< (point-min) (point))
		      (equal (buffer-substring-no-properties (- (point) 1)
							     (point))
			     " "))
	    (backward-delete-char 1))
	  ; delete a preceding newline, if any
	  (if (equal (buffer-substring-no-properties (- (point) 1)
						     (point))
		     "\n")
	    (backward-delete-char 1))
	  ; ConTeXt's display math with automatic equation numbering
	  (insert "\n\\placeformula\\startformula\n")
	  (save-excursion (insert "\n\\stopformula")))
      ; else: just doing inline math
      (insert-balanced ?\$ ?\$))))

;; (TeX-add-style-hook
;;  "beamer"
;;  (lambda () (setq TeX-PDF-mode t)))
(setq TeX-output-view-style
      '(("^dvi$"
         ("^landscape$" "^pstricks$\\|^pst-\\|^psfrag$")
         "%(o?)dvips -t landscape %d -o && gv %f")
        ("^dvi$" "^pstricks$\\|^pst-\\|^psfrag$" "%(o?)dvips %d -o && gv %f")
        ("^dvi$"
         ("^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "^landscape$")
         "%(o?)xdvi %dS -paper a4r -s 0 %d")
        ("^dvi$" "^a4\\(?:dutch\\|paper\\|wide\\)\\|sem-a4$" "%(o?)xdvi %dS -paper a4 %d")
        ("^dvi$"
         ("^a5\\(?:comb\\|paper\\)$" "^landscape$")
         "%(o?)xdvi %dS -paper a5r -s 0 %d")
        ("^dvi$" "^a5\\(?:comb\\|paper\\)$" "%(o?)xdvi %dS -paper a5 %d")
        ("^dvi$" "^b5paper$" "%(o?)xdvi %dS -paper b5 %d")
        ("^dvi$" "^letterpaper$" "%(o?)xdvi %dS -paper us %d")
        ("^dvi$" "^legalpaper$" "%(o?)xdvi %dS -paper legal %d")
        ("^dvi$" "^executivepaper$" "%(o?)xdvi %dS -paper 7.25x10.5in %d")
        ("^dvi$" "." "%(o?)xdvi %dS %d")
        ("^pdf$" "." "evince %o")
        ("^html?$" "." "firefox %o")))

(add-hook 'LaTeX-mode-hook 
          (lambda()
            (add-to-list 'TeX-command-list '("XeLaTeX" "%`xelatex%(mode)%' %t" TeX-run-TeX nil t))
            (setq TeX-command-default "XeLaTeX")))
(add-hook 'ConTeXt-mode-hook 
          (lambda()
            (add-to-list 'TeX-command-list 
                         '("xConTeXt" "texexec --batch --xtx %t" 
                           TeX-run-TeX nil t))
            (add-to-list 'LaTeX-verbatim-macros-with-delims "type")
            (add-to-list 'LaTeX-verbatim-macros-with-braces "type")
            (add-to-list 'LaTeX-verbatim-environments "typing")
))
(add-hook 'ConTeXt-mode-hook 
          (lambda()
            (add-to-list 'TeX-command-list 
                         '("MkIV" "source ~/software/context/tex/setuptex; context --batch %t" 
                           TeX-run-TeX nil t))))

(add-hook 'LaTeX-mode-hook
          (lambda ()
            ;; Some faces
            (set-face-attribute
             'font-latex-verbatim-face nil
             :inherit 'fixed-pitch 
             :foreground "burlywood" 
             :family "Courier New")))

(add-hook 'ConTeXt-mode-hook
          (lambda ()
            (set-face-attribute
             'font-latex-sedate-face nil
             :foreground "#66ccff")))

;; CDLaTeX
(autoload 'cdlatex-mode "cdlatex" "CDLaTeX Mode" t)
(autoload 'turn-on-cdlatex "cdlatex" "CDLaTeX Mode" nil)
(add-hook 'LaTeX-mode-hook 'turn-on-cdlatex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-cdlatex)   ; with Emacs latex mode

(add-hook 'tex-mode-hook
          '(lambda ()
             (define-key LaTeX-mode-map (kbd "C-c /") 'LaTeX-close-environment)
             (define-key LaTeX-mode-map (kbd "C-TAB") 'indent-according-to-mode)))
