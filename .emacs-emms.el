(add-to-list 'load-path "~/.emacs.d/emms")

(require 'emms-source-file)
(require 'emms-source-playlist)
(require 'emms-info)
(require 'emms-cache)
(require 'emms-playlist-mode)
;; (require 'emms-mode-line)
(require 'emms-playing-time)
(require 'emms-player-mpd)
(require 'emms-playlist-sort)
(require 'emms-mark)
(require 'emms-browser)
(require 'emms-lyrics)
(require 'emms-last-played)
(require 'emms-score)
(require 'emms-lastfm)

(setq emms-playlist-default-major-mode 'emms-playlist-mode)
(add-to-list 'emms-track-initialize-functions 'emms-info-initialize-track)
;; (emms-mode-line 1)
;; (emms-mode-line-blank)
(emms-playing-time 1)
(emms-lyrics 1)
(add-hook 'emms-player-started-hook 'emms-last-played-update-current)
(emms-score 1)
(when (fboundp 'emms-cache)           ; work around compiler warning
  (emms-cache 1))
(setq emms-score-default-score 3)

(require 'emms-lastfm)
(setq emms-lastfm-username emms-lastfm-nick
      emms-lastfm-password emms-lastfm-pw)
(emms-lastfm-activate 1)


(defun emms-mpd-init ()
  "Start MPD and connet Emms to it."
  (interactive)
  (shell-command "mpd")
;;   (shell-command "mpdscribble &")
  (emms-player-mpd-connect))

;; players
(require 'emms-player-mpd)
(setq emms-player-mpd-server-name "localhost")
(setq emms-player-mpd-server-port "6600")
(add-to-list 'emms-info-functions 'emms-info-mpd)
(add-to-list 'emms-player-list 'emms-player-mpd)
(setq emms-player-mpd-sync-playlist t)

(setq emms-source-file-default-directory "/mnt/shared/music")
(setq emms-player-mpd-music-directory "/mnt/shared/music")
(setq emms-info-auto-update t)
(setq emms-lyrics-scroll-p nil)
(setq emms-lyrics-display-on-minibuffer t)
(setq emms-lyrics-display-on-modeline nil)
(setq emms-lyrics-dir "~/.lyrics")

;; Playlist format
(defun my-describe (track)
  (let* ((empty "...")
         (name (emms-track-name track))
         (type (emms-track-type track))
         (short-name (file-name-nondirectory name))
         (play-count (or (emms-track-get track 'play-count) 0))
         (last-played (or (emms-track-get track 'last-played) '(0 0 0)))
         (artist (or (emms-track-get track 'info-artist) empty))
         (year (emms-track-get track 'info-year))
         (playing-time (or (emms-track-get track 'info-playing-time) 0))
         (min (/ playing-time 60))
         (sec (% playing-time 60))
         (album (or (emms-track-get track 'info-album) empty))
         (tracknumber (emms-track-get track 'info-tracknumber))
         (short-name (file-name-sans-extension
                      (file-name-nondirectory name)))
         (title (or (emms-track-get track 'info-title) short-name))
         (rating (emms-score-get-score name))
         (rate-char ?☭)
         )
    (format "%15s - %.4s [%-20s] - %2s. %-30s |%2d %s"
            artist
            year
            album
            tracknumber
            title
            play-count
            (make-string rating rate-char)))
)

(setq emms-track-description-function 'my-describe)

;; (global-set-key (kbd "C-<f9> t") 'emms-play-directory-tree)
(global-set-key (kbd "C-<f9> <f9>") 'emms-mpd-init)
(global-set-key (kbd "C-<f9> d") 'emms-play-dired)
(global-set-key (kbd "C-<f9> x") 'emms-start)
(global-set-key (kbd "C-<f9> v") 'emms-stop)
(global-set-key (kbd "C-<f9> n") 'emms-next)
(global-set-key (kbd "C-<f9> p") 'emms-previous)
(global-set-key (kbd "C-<f9> o") 'emms-show)
(global-set-key (kbd "C-<f9> h") 'emms-shuffle)
;; (global-set-key (kbd "C-<f9> e") 'emms-play-file)
(global-set-key (kbd "C-<f9> SPC") 'emms-pause)
(global-set-key (kbd "C-<f9> f") 'emms-no-next)
(global-set-key (kbd "C-<f9> a") 'emms-add-directory-tree)
(global-set-key (kbd "C-<f9> b") 'emms-smart-browse)
(global-set-key (kbd "C-<f9> l") 'emms-playlist-mode-go)

(global-set-key (kbd "C-<f9> r") 'emms-toggle-repeat-track)
(global-set-key (kbd "C-<f9> R") 'emms-toggle-repeat-playlist)
(global-set-key (kbd "C-<f9> m") 'emms-lyrics-toggle-display-on-minibuffer)
(global-set-key (kbd "C-<f9> M") 'emms-lyrics-toggle-display-on-modeline)

(global-set-key (kbd "C-<f9> <left>")  (lambda () (interactive) (emms-seek -10)))
(global-set-key (kbd "C-<f9> <right>") (lambda () (interactive) (emms-seek +10)))
(global-set-key (kbd "C-<f9> <down>")  (lambda () (interactive) (emms-seek -60)))
(global-set-key (kbd "C-<f9> <up>")    (lambda () (interactive) (emms-seek +60)))

(global-set-key (kbd "C-<f9> s u") 'emms-score-up-playing)
(global-set-key (kbd "C-<f9> s d") 'emms-score-down-playing)
(global-set-key (kbd "C-<f9> s o") 'emms-score-show-playing)
(global-set-key (kbd "C-<f9> s s") 'emms-score-set-playing)

;; Faces
(if (window-system)
    ((lambda ()
       (set-face-attribute
        'emms-browser-artist-face nil
        :family "Arno Pro")
       )
))

;; A fix for that EMMS fails to play mp4 and m4a files
;; (defun emms-player-mpd-get-supported-regexp ()
;;   "Returns a regexp of file extensions that MusicPD supports,
;; or nil if we cannot figure it out."
;;   (let ((suffix (split-string 
;;                  (shell-command-to-string "mpd --version | grep mp3")
;;                  " ")))
;;     (defun remove-return (seq)
;;       (if (eq '() seq)
;;           seq
;;         (if (string= "\n" (car seq))
;;             (remove-return (cdr seq))
;;           (cons (car seq) (remove-return (cdr seq))))))
;;     (concat "\\`http://\\|\\.\\(m3u\\|pls\\|"
;;             (regexp-opt (remove-return suffix))
;;             "\\)\\'")))

(setq emms-player-mpd-supported-regexp
      (or (emms-player-mpd-get-supported-regexp)
          (concat "\\`http://\\|"
                  (emms-player-simple-regexp
                   "m3u" "ogg" "flac" "mp3" "wav" "mod" "au" "aiff"))))
(emms-player-set emms-player-mpd 'regex emms-player-mpd-supported-regexp)
      
