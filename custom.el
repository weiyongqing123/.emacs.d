(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(cua-mode t nil (cua-base))
 '(custom-enabled-themes (quote (sanityinc-solarized-dark)))
 '(custom-safe-themes (quote ("4aee8551b53a43a883cb0b7f3255d6859d766b6c5e14bcb01bed572fcbef4328" "4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(org-agenda-files (quote ("~/UbuntuOne/life/task.org")))
 '(send-mail-function nil)
 '(session-use-package t nil (session))
 '(tool-bar-mode nil))


;;自定义的设置
(global-set-key [(control tab)] 'set-mark-command)

;;自动识别中文编码的文件
;;(require 'unicad)

;;插入时间（不包括日期）
(defun insert-short-time ()
  (interactive)
  (insert (format-time-string "%H:%M:%S" (current-time))))

;; save the password
(setq epa-file-cache-passphrase-for-symmetric-encryption t)
 ;; auto-save
(setq epa-file-inhibit-auto-save nil)

;;拼写检查的词典
(ispell-change-dictionary "american" t)

;;启动自动最大化
(setq initial-frame-alist '((top . 0)(left . 0)(width . 200)(height . 60)))

;;任务计划的映射
(setq org-agenda-files (list "~/UbuntuOne/life/task.org"))


;;自定义的宏

;;缩略词配置
;Abbrev-mode always open
(setq default-abbrev-mode t)
(setq abbrev-file-name;; tell emacs where to read abbrev
   "~/.emacs.d/.abbrev_defs");; definitions from...
(setq save-abbrevs t);; save abbrevs when files are saved
(quietly-read-abbrev-file);; reads the abbreviations file on startup

;; author: pluskid
;; 调用 stardict 的命令行程序 sdcv 来查辞典
;; 如果选中了 region 就查询 region 的内容，否则查询当前光标所在的单词
;; 查询结果在一个叫做 *sdcv* 的 buffer 里面显示出来，在这个 buffer 里面
;; 按 q 可以把这个 buffer 放到 buffer 列表末尾，按 d 可以查询单词
(global-set-key (kbd "C-c d") 'kid-sdcv-to-buffer)
(defun kid-sdcv-to-buffer ()
  (interactive)
  (let ((word (if mark-active
                  (buffer-substring-no-properties (region-beginning) (region-end))
                  (current-word nil t))))
    (setq word (read-string (format "Search the dictionary for (default %s): " word)
                            nil nil word))
    (set-buffer (get-buffer-create "*sdcv*"))
    (buffer-disable-undo)
    (erase-buffer)
    (let ((process (start-process-shell-command "sdcv" "*sdcv*" "sdcv" "-n" word)))
      (set-process-sentinel
       process
       (lambda (process signal)
         (when (memq (process-status process) '(exit signal))
           (unless (string= (buffer-name) "*sdcv*")
             (setq kid-sdcv-window-configuration (current-window-configuration))
             (switch-to-buffer-other-window "*sdcv*")
             (local-set-key (kbd "d") 'kid-sdcv-to-buffer)
             (local-set-key (kbd "q") (lambda ()
                                        (interactive)
                                        (bury-buffer)
                                        (unless (null (cdr (window-list))) ; only one window
                                          (delete-window)))))
           (goto-char (point-min))))))))


;;快速标示类似isearch
(defvar smart-use-extended-syntax nil
  "If t the smart symbol functionality will consider extended
syntax in finding matches, if such matches exist.")
(defvar smart-last-symbol-name ""
  "Contains the current symbol name.
This is only refreshed when `last-command' does not contain
either `smart-symbol-go-forward' or `smart-symbol-go-backward'")
(make-local-variable 'smart-use-extended-syntax)
(defvar smart-symbol-old-pt nil
  "Contains the location of the old point")
(defun smart-symbol-goto (name direction)
  "Jumps to the next NAME in DIRECTION in the current buffer.
DIRECTION must be either `forward' or `backward'; no other option
is valid."
  ;; if `last-command' did not contain
  ;; `smart-symbol-go-forward/backward' then we assume it's a
  ;; brand-new command and we re-set the search term.
  (unless (memq last-command '(smart-symbol-go-forward
                               smart-symbol-go-backward))
    (setq smart-last-symbol-name name))
  (setq smart-symbol-old-pt (point))
  (message (format "%s scan for symbol \"%s\""
                   (capitalize (symbol-name direction))
                   smart-last-symbol-name))
  (unless (catch 'done
            (while (funcall (cond
                             ((eq direction 'forward) ; forward
                              'search-forward)
                             ((eq direction 'backward) ; backward
                              'search-backward)
                             (t (error "Invalid direction"))) ; all others
                            smart-last-symbol-name nil t)
              (unless (memq (syntax-ppss-context
                             (syntax-ppss (point))) '(string comment))
                (throw 'done t))))
    (goto-char smart-symbol-old-pt)))
(defun smart-symbol-go-forward ()
  "Jumps forward to the next symbol at point"
  (interactive)
  (smart-symbol-goto (smart-symbol-at-pt 'end) 'forward))
(defun smart-symbol-go-backward ()
  "Jumps backward to the previous symbol at point"
  (interactive)
  (smart-symbol-goto (smart-symbol-at-pt 'beginning) 'backward))
(defun smart-symbol-at-pt (&optional dir)
  "Returns the symbol at point and moves point to DIR (either `beginning' or `end') of the symbol.
If `smart-use-extended-syntax' is t then that symbol is returned
instead."
  (with-syntax-table (make-syntax-table)
    (if smart-use-extended-syntax
        (modify-syntax-entry ?. "w"))
    (modify-syntax-entry ?_ "w")
    (modify-syntax-entry ?- "w")
    ;; grab the word and return it
    (let ((word (thing-at-point 'word))
          (bounds (bounds-of-thing-at-point 'word)))
      (if word
          (progn
            (cond
             ((eq dir 'beginning) (goto-char (car bounds)))
             ((eq dir 'end) (goto-char (cdr bounds)))
             (t (error "Invalid direction")))
            word)
        (error "No symbol found")))))
(global-set-key (kbd "M-n") 'smart-symbol-go-forward)
(global-set-key (kbd "M-p") 'smart-symbol-go-backward)


;;yasnippet
(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

;;projectile-mode
(projectile-global-mode)


(define-key global-map [f1] 'my-recentf-open)
(define-key global-map [f2] 'save-buffer)
(define-key global-map [f5] 'call-last-kbd-macro)
(define-key global-map [f6] 'bookmark-set)
(define-key global-map [f7] 'bookmark-jump)
(define-key global-map [f8] 'list-bookmarks)
(define-key global-map [f9] 'goto-last-change)
(define-key global-map [f10] 'ido-switch-buffer)
(define-key global-map [f11] 'save-some-buffers)
(define-key global-map [f12] 'kill-buffer)
(define-key global-map   (kbd "C-'") 'duplicate-line)
(define-key global-map   (kbd "C-S-o") 'projectile-find-file)
(define-key global-map  (kbd "C-<up>") 'previous-buffer)
(define-key global-map  (kbd "C-<down>") 'next-buffer)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)
(global-set-key (kbd "C-t")  'insert-short-time)
(global-set-key (kbd "C-<f5>")  'window-configuration-to-register)
(global-set-key (kbd "C-<f6>")  'point-to-register)
(global-set-key (kbd "C-<f7>")  'jump-to-register)
(global-set-key (kbd "C-<f8>")  'list-registers)


;;(global-set-key [S-down-mouse-1] 'mouse-appearance-menu)
(global-set-key [S-down-mouse-1] 'mouse-save-then-kill)
;;(global-set-key [C-S-mouse-1] 'mouse-save-then-kill)


(setq ido-enable-flex-matching t)

;;打开最近访问tabletable文件
(defun my-recentf-open ()
  "open recent files.  In ido style if applicable --lgfang"
  (interactive)
  (let* ((path-table (mapcar
                      (lambda (x) (cons (file-name-nondirectory x) x))
                      recentf-list))
         (file-list (mapcar (lambda (x) (file-name-nondirectory x))
                            recentf-list))
         (complete-fun (if (require 'ido nil t)
                           'ido-completing-read
                         'completing-read))
         (fname (funcall complete-fun "File Name: " file-list)))
    (find-file (cdr (assoc fname path-table)))))



;;页面标签栏
;; (add-to-list 'load-path
;;               "~/.emacs.d/elpa/tabbar")
;; (require 'tabbar)
;; (tabbar-mode t)

;;将子窗口自动编号,然后按M-0…9跳转
(add-to-list 'load-path "~/.emacs.d/elpa/window-numbering")
(require 'window-numbering )
(window-numbering-mode 1)

;;给相关模式加上括号匹配输入
(autopair-global-mode) ;; enable autopair in all buffers

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
