(require 'org-install)

(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(add-hook 'org-mode-hook 'turn-on-font-lock)

(setq org-log-done t)
(setq org-agenda-include-diary t)
(setq org-icalendar-include-todo t)

(cond
 (linuxp
  (setq org-agenda-files '("/mnt/shared/text/misc/plan.org"
                           "/mnt/shared/text/misc-study/abroad/apply.org")))
 (aquap
  (setq org-agenda-files '("/Volumes/Shared/text/misc/plan.org"
                           "/Volumes/Shared/text/misc-study/abroad/apply.org")))
)

(add-hook 'org-mode-hook
          (lambda () (define-key org-mode-map (kbd "C-c C-a") 'show-all)))

(setq org-hide-leading-stars t)
(if (window-system)
    (add-hook 'org-mode-hook
              (lambda ()
                (set-face-attribute
                 'org-hide nil
                 :foreground "#2e3735"))))

(setq org-export-html-style
      "<style type=\"text/css\">
html
{ 
    font-family: sans-serif;
    font-size: 12px;
}

body
{
    width: 640px;
    border: 30px solid #888;
    padding: 10px;
    margin-left: 12%;
    background-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAIAAAC0tAIdAAAAVklEQVQokY3PMQ7AIAxDUcPCnPvfEVaY0gWJNiSp//xkyWX2jldNBHGVp2uMytOzzdCtSQqgqCpJYV7mtImE+qbhtkt9HVFHJ9TqnH70Lz2aoVuTFMAD2WUv7lkTS9gAAAAASUVORK5CYII=);
    background-repeat: repeat;
    background-attachment: fixed;
}

b
{
    font-family: monospace;
    font-weight: normal;
    font-size: 80%;
}

ul
{
    list-style-image: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAQAAAAECAYAAACp8Z5+AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAAfwAAAH8BuLbMiQAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAAWSURBVAiZYzx16tR/BiTAxIAGCAsAAN1QA2Xx3HxpAAAAAElFTkSuQmCC);
}

h3
{
    font-family: serif;
}

.title
{
    text-align: center;
    font-family: serif;
}

.todo, .done, .timestamp
{
    font-family: monospace;
    font-size: 80%;
    background-color: #ddd;
}
</style>")
