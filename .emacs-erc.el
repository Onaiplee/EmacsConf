(require 'erc)
(require 'erc-ring)
(require 'erc-services)
(require 'erc-fill)
(require 'erc-autoaway)
(if linuxp (require 'erc-log))
(require 'ssl)
(require 'smiley)

(erc-netsplit-mode t)
(erc-ring-enable)
(if linuxp (erc-log-enable))

(setq erc-nick "Darksair")
(setq erc-nick-oftc "Corsair")
(setq erc-bitlbee-server "localhost")
;; (setq erc-away-nickname "Awaysair")
(setq erc-user-full-name "Corsair Sun")


(erc-services-mode 1)
(setq erc-prompt-for-nickserv-password nil)
(setq erc-server-auto-reconnect nil)

;; Formatting
(setq erc-input-line-position -2)
;; (setq erc-fill-prefix "    ")
(setq erc-fill-function 'erc-fill-static)
(setq erc-fill-static-center 15)
;; Auto un-away
(setq erc-auto-discard-away t)
;; Spell check
(erc-spelling-mode 1)
;; Do not make nicks as buttons
(setq erc-button-buttonize-nicks nil)
;; Don't track server buffer
(setq erc-track-exclude-server-buffer t)
;; Don't track join/quit
(setq erc-track-exclude-types '("NICK" "333" "353" "JOIN" "PART" "QUIT"))
;; Logging
(if linuxp
    (setq erc-log-channels t
          erc-log-channels-directory "~/logs/erc"
          erc-log-insert-log-on-open nil
          erc-log-file-coding-system 'utf-8))

;; Channel specific prompt
(setq erc-prompt (lambda ()
                   (if (and (boundp 'erc-default-recipients) 
                            (erc-default-target))
                       (erc-propertize (concat (erc-default-target) ">")
                                       'read-only t 
                                       'rear-nonsticky t 
                                       'front-nonsticky t)
                     (erc-propertize (concat "ERC>") 
                                     'read-only t 
                                     'rear-nonsticky t 
                                     'front-nonsticky t))))

(setq erc-autojoin-channels-alist '(("freenode.net"
                                     "#ubuntu-cn" "#archlinux"
                                     "#xmonad" "#ppmm"
                                     "#emacs")
                                    ("oftc.net" "#arch-cn"
                                     "#wormux-cn" "#njulug")))
(setq erc-pals '("juansheng" "sven" "steamedfish" "sungamma" "aBiNg"))

(setq erc-quit-reason-various-alist
      '(("dinner" "Having dinner...")
        ("z" "Zzz...")
        ("^$" yow)))
(setq erc-quit-reason 'erc-quit-reason-various)

;; Automatically truncate buffer
(defvar erc-insert-post-hook)
(add-hook 'erc-insert-post-hook
          'erc-truncate-buffer)
(setq erc-truncate-buffer-on-save t)

;; Smiley
(setq gnus-smiley-file-types '("xpm" "pbm" "png"))
(setq smiley-data-directory (expand-file-name "~/.emacs.d/smiley/tango"))
(setq smiley-style 'tango)
(setq smiley-cached-regexp-alist nil)
(smiley-update-cache)
(setq smiley-regexp-alist '(("\\(:-\\*\\)\\W" 1 "kiss")
                            ("\\(:-[Ss]\\)\\W" 1 "confused")
                            ("\\(:-[Xx]\\)\\W" 1 "frown")
                            ("\\(:-[pP]\\)\\W" 1 "tongue")
                            ("\\(;-?)\\)\\W" 1 "blink")
                            ("\\(:-]\\)\\W" 1 "forced")
                            ("\\(8-)\\)\\W" 1 "braindamaged")
                            ("\\(:-|\\)\\W" 1 "indifferent")
                            ("\\(:-[/\\]\\)\\W" 1 "wry")
                            ("\\(:-(\\)\\W" 1 "sad")
                            ("\\(X-)\\)\\W" 1 "dead")
                            ("\\(:-{\\)\\W" 1 "frown")
                            ("\\(>:-)\\)\\W" 1 "evil")
                            ("\\(;-(\\)\\W" 1 "cry")
                            ("\\(:-D\\)\\W" 1 "grin")
                            ("\\(\\^?:-?)\\)\\W" 1 "smile")))
(erc-smiley-enable)

;; SSL
;; (setq tls-program '("openssl s_client -connect %h:%p -no_ssl2 -ign_eof -CAfile /home/corsair/.cert/CAs.pem -cert /home/corsair/.cert/oftc/nick.pem"
;;                     "gnutls-cli --priority secure256 --x509cafile /home/corsair/.cert/CAs.pem --x509certfile /home/corsair/.cert/oftc/nick.pem -p %p %h" 
;;                     "gnutls-cli --priority secure256 -p %p %h"))

;; Work around for oftc auto-identify
(add-hook 'erc-after-connect
          (lambda (SERVER NICK)
             (cond
              ((string-match "oftc\\.net" SERVER)
               (erc-message "PRIVMSG" (concat "NickServ identify " oftcpw))))))

;; Functions
(defun erc-start ()
  (interactive)
  (erc :server "irc.freenode.net" :port 6667 :nick erc-nick :password freenodepw :full-name "Darksair")
  (erc-tls :server "irc.oftc.net" :port 6697 :nick erc-nick-oftc :password oftcpw :full-name "Corsair"))

(defun erc-bitlbee ()
  (interactive)
  ;; (erc :server "127.0.0.1" :port 6667 :nick erc-nick :password bitlbeepw))
  (erc :server erc-bitlbee-server :port 6667 :nick erc-nick :password bitlbeepw))
(add-hook 'erc-join-hook 'bitlbee-identify)
(defun bitlbee-identify ()
   "If we're on the bitlbee server, send the identify command to
 the &bitlbee channel."
   (when (and (string= erc-bitlbee-server erc-session-server)
              (string= "&bitlbee" (buffer-name)))
     (erc-message "PRIVMSG" (format "%s identify %s" 
                                    (erc-default-target) 
                                    bitlbeepw))))

;; A hack so that when unaway in oftc, change nick to `erc-nick-oftc'
;; instead of `erc-nick'
;; (defun erc-process-away (proc away-p)
;;   "Toggle the away status of the user depending on the value of AWAY-P.

;; If nil, set the user as away.
;; If non-nil, return from being away."
;;   (let ((sessionbuf (process-buffer proc)))
;;     (when sessionbuf
;;       (with-current-buffer sessionbuf
;; 	(when erc-away-nickname
;; 	  (erc-log (format "erc-process-away: away-nick: %s, away-p: %s"
;;                        erc-away-nickname away-p))
;; 	  (erc-cmd-NICK (if away-p
;;                         erc-away-nickname
;;                       (if (string= (erc-current-network) "oftc")
;;                           erc-nick-oftc
;;                         erc-nick))))
;; 	(cond
;; 	 (away-p
;; 	  (setq erc-away (current-time)))
;; 	 (t
;; 	  (let ((away-time erc-away))
;; 	    ;; away must be set to NIL BEFORE sending anything to prevent
;; 	    ;; an infinite recursion
;; 	    (setq erc-away nil)
;; 	    (save-excursion
;; 	      (set-buffer (erc-active-buffer))
;; 	      (when erc-public-away-p
;; 		(erc-send-action
;; 		 (erc-default-target)
;; 		 (if away-time
;; 		     (format "is back (gone for %s)"
;; 			     (erc-sec-to-time
;; 			      (erc-time-diff
;; 			       (erc-emacs-time-to-erc-time away-time)
;; 			       (erc-current-time))))
;; 		   "is back")))))))))
;;     (erc-update-mode-line)))

(defun erc-cmd-THINK (&rest line)
  (let ((text
         (concat ".oO{ "
                 (erc-trim-string (mapconcat 'identity line " "))
                 " }")))
    (erc-send-action (erc-default-target) text)))

(defun erc-cmd-SLAP (&rest nick)
  (if (not (equal '() nick))
      (erc-send-action (erc-default-target)
                       (concat "slaps "
                               (car nick)
                               " with a UNIX manual."))))

(defun erc-cmd-HOWMANY (&rest ignore)
  "Display how many users (and ops) the current channel has."
  (erc-display-message nil 'notice (current-buffer)
                       (let ((hash-table (with-current-buffer
                                             (erc-server-buffer)
                                           erc-server-users))
                             (users 0)
                             (ops 0))
                         (maphash (lambda (k v)
                                    (when (member (current-buffer)
                                                  (erc-server-user-buffers v))
                                      (incf users))
                                    (when (erc-channel-user-op-p k)
                                      (incf ops)))
                                  hash-table)
                         (format
                          "There are %s users (%s ops) on the current channel"
                          users ops))))

;; Show elisp and eval result
(defun erc-cmd-SHOW (&rest form)
  "Eval FORM and send the result and the original form as:
 FORM => (eval FORM)."
  (let* ((form-string (mapconcat 'identity form " "))
         (result
          (condition-case err
              (eval (read-from-whole-string form-string))
            (error
             (format "Error: %s" error)))))
    (erc-send-message (format "%s => %S" form-string result))))
;; Show elisp
(defun erc-cmd-EL (&rest form)
  "Show a elisp."
  (erc-send-message (concat 
                     (erc-trim-string (mapconcat 'identity form " "))
                     "  <-- hit C-x C-e here")))

;; Show info page
(defun erc-cmd-INFO (&rest ignore)
      "Send current info node."
      (unless (get-buffer "*info*")
	(error "No *info* buffer"))
      (let (output)
	(with-current-buffer "*info*"
	  (let* ((file (file-name-nondirectory Info-current-file))
		 (node Info-current-node))
	    (setq output (format "(info \"(%s)%s\") <-- hit C-x C-e to evaluate"
				 file node))))
	(erc-send-message output)))

;; Show off :-p
(defun erc-cmd-SHOWOFF (&rest ignore)
  "Show off implementation"
  (let* ((chnl (erc-buffer-list))
         (srvl (erc-buffer-list 'erc-server-buffer-p))
         (memb (apply '+ (mapcar (lambda (chn)
                                   (with-current-buffer chn
                                     (1- (length (erc-get-channel-user-list)))))
                                 chnl)))
         (show (format "is connected to %i networks and talks in %i chans to %i ppl overall :>"
                       (length srvl)
                       (- (length chnl) (length srvl))
                       memb)))
    (erc-send-action (erc-default-target) show)))
(defalias 'erc-cmd-SO 'erc-cmd-SHOWOFF)
  
(defun erc-cmd-DETAILED-SHOWOFF (&rest ignore)
  "Show off implementation enriched with even more with details"
  (let* ((chnl (erc-buffer-list))
         (srvl (erc-buffer-list 'erc-server-buffer-p)))
    (mapcar (lambda (srv)
              (let* ((netn (with-current-buffer srv erc-session-server))
                     (netp (with-current-buffer srv erc-session-port))
                     (chns (remove-if-not
                            (lambda (chn)
                              (and (string= netn (with-current-buffer chn erc-session-server))
                                   (eq netp (with-current-buffer chn erc-session-port))))
                            chnl))
                     (chnn (1- (length chns)))
                     (chnm (remove nil
                                   (mapcar (lambda (chn)
                                             (with-current-buffer chn
                                               (erc-get-channel-user-list)))
                                           chns)))
                     (chnmn (apply '+ (mapcar '1- (mapcar 'length chnm))))
                     (show (format "is connected to %s (%s), talking to %i users in %i chans"
                                   netn
                                   (buffer-name srv)
                                   chnmn
                                   chnn)))
                (erc-send-action (erc-default-target) show)
                (sit-for 1)))
            srvl)))
(defalias 'erc-cmd-DSO 'erc-cmd-DETAILED-SHOWOFF)

;; Now playing~ :-)
(if linuxp
    ((lambda ()
      (defun mpd-erc-np ()
        (concat "is listening to "
                (let* ((string (shell-command-to-string "mpc")))
                  (string-match "[^/]*$" string)
                  (match-string 0 string))))
      (defun erc-cmd-NP ()
        (let ((np (mpd-erc-np)))
          (if (string-match "\n" np)
              nil
            (erc-send-action (erc-default-target) (mpd-erc-np)))))
)))
;; Say hi to everyone, use with CAUTION!!
(defun erc-cmd-HI ()
  (defun hi-to-nicks (nick-list)
    (if (eq nick-list '())
        nil
      (erc-send-message (concat "Hi, " (car nick-list)))
      (sleep-for 1)
      (hi-to-nicks (cdr nick-list))))

  (let ((nicks (erc-get-channel-nickname-list)))
    (hi-to-nicks nicks)))

;; H4x0r code
(add-hook 'erc-send-pre-hook 'erc-maybe-h4x0r)

(define-minor-mode erc-h4x0r-mode
  "Toggle automatic usage of h4x0r code for everything you type in ERC.")

(defun erc-maybe-h4x0r (ignore)
  "Change the text to h4x0r code, if `erc-h4x0r-mode' is non-nil."
  (when erc-h4x0r-mode
	(with-temp-buffer
	  (insert str)
	  (erc-h4x0r)
	  (setq str (buffer-string)))))

(defun erc-h4x0r ()
  "Transform the buffer into h4x0r code."
  (h4x0r-region (point-min) (point-max)))

(autoload 'h4x0r-region "h4x0r")
;; end of h4x0r code

;; My replaces
(defun erc-my-replace (str)
  (replace-regexp-in-string
   "。。。" "..."
   (replace-regexp-in-string
    "～" "~"
    (replace-regexp-in-string
     "\\^\\^" "^_^"
     (replace-regexp-in-string
      "…………" "^_^"
    str)))))

(add-hook 'erc-send-pre-hook
  (lambda (s1)
    (setq str (erc-my-replace s1))))

(if linuxp
    ((lambda ()
      (defun erc-play-sound (file-name)
        (call-process "/usr/bin/aplay" nil 0 nil file-name))
      ;;   (shell-command (concat "aplay \"" file-name "\" &")))

      ;; (defun erc-osd-display (text)
      ;;   (call-process "/bin/sh" nil 0 nil "-c"
      ;;                 (concat "echo '" (replace-regexp-in-string 
      ;;                                   "^<\\(.*\\)> \\(.*\\)"
      ;;                                   "<span foreground=\"yellow\">&lt;\\1&gt;</span> \\2"
      ;;                                   text)
      ;;                         "' | ghosd_cat -F 'Consolas 12' -d 2000 -m 200 -s 0 -x 50 -y 2")))
      (defun erc-osd-display (text)
        (let ((nick (replace-regexp-in-string "^<\\(.*\\)> \\(.*\\)"
                                              "\\1" text))
              (msg (replace-regexp-in-string "^<\\(.*\\)> \\(.*\\)"
                                             "\\2" text)))
          (call-process "/usr/bin/notify-send" nil 0 nil nick msg
                        "-i" "notification-message-IM")
          ))

      ;; Sound notification
      (setq erc-play-command "aplay")
      (add-hook 'erc-insert-pre-hook
                (lambda (msg-str)
                  (if (and (string= erc-session-server erc-bitlbee-server)
                           (string-match "^<" msg-str)
                           (not (string-match "^<root>" (propertize msg-str 'face nil))))
                      ((lambda ()
                         (erc-play-sound "/mnt/shared/sounds/mac/New Mail.wav")
                         (erc-osd-display (substring msg-str 0 -1))))))
                t)

      (add-hook 'erc-text-matched-hook
                (lambda (match-type nickuserhost message)
                  (if (and (eq match-type 'current-nick)
                           (not (string= erc-session-server erc-bitlbee-server)))
                      (erc-play-sound "/mnt/shared/sounds/mac/New Messages.wav"))))
)))
