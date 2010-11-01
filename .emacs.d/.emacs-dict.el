(add-to-list 'load-path "~/.emacs.d/dictionary")

(autoload 'dictionary-search "dictionary" 
  "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary"
  "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary" 
  "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary"
  "Create a new dictionary buffer" t)
(autoload 'dictionary-mouse-popup-matching-words "dictionary"
  "Display entries matching the word at the cursor" t)
(autoload 'dictionary-popup-matching-words "dictionary"
  "Display entries matching the word at the point" t)
(autoload 'dictionary-tooltip-mode "dictionary"
  "Display tooltips for the current word" t)
(unless (boundp 'running-xemacs)
  (autoload 'global-dictionary-tooltip-mode "dictionary"
    "Enable/disable dictionary-tooltip-mode for all buffers" t))

;; key bindings
(global-set-key "\C-cs" 'dictionary-search)
(global-set-key "\C-cm" 'dictionary-match-words)

(setq dictionary-server "localhost")
(setq dictionary-tooltip-dictionary "webster1913")
;; (global-dictionary-tooltip-mode 1)

;; activate for all text-based modes
;; (add-hook 'text-mode-hook 'dictionary-tooltip-mode)
(if (boundp 'running-xemacs)
    (global-set-key [(control button3)] 'dictionary-mouse-popup-matching-words)
  (global-set-key [mouse-3] 'dictionary-mouse-popup-matching-words))
