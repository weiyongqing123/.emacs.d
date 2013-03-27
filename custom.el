(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes (quote ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(org-agenda-files (quote ("~/UbuntuOne/life/task.org")))
 '(send-mail-function nil)
 '(session-use-package t nil (session)))

;;页面标签栏
(add-to-list 'load-path
              "~/.emacs.d/elpa/tabbar")
(require 'tabbar)
(tabbar-mode t)

;;将子窗口自动编号,然后按M-0…9跳转
(add-to-list 'load-path "~/.emacs.d/elpa/window-numbering.el")
(require 'window-numbering )
(window-numbering-mode 1)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
