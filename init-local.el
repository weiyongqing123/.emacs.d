;;; 编译el文件
;;(byte-recompile-directory "~/.emacs.d/")
;;自定义的设置
(global-set-key [(control tab)] 'set-mark-command)

;;显示行号
(global-linum-mode t)

;;插入时间（不包括日期）
(defun insert-short-time ()
  (interactive)
  (insert (format-time-string "%H:%M:%S " (current-time))))
;;插入日期
(defun insert-short-day ()
  (interactive)
  (insert (format-time-string "%Y-%m-%d " (current-time))))

;; save the password
(setq epa-file-cache-passphrase-for-symmetric-encryption t)
;; auto-save
(setq epa-file-inhibit-auto-save nil)

;;拼写检查的词典
(ispell-change-dictionary "american" t)
(global-set-key (kbd "C-?")  'ispell-complete-word)

;;自定义的函数


;;缩略词配置
;Abbrev-mode always open
(setq default-abbrev-mode t)
(setq abbrev-file-name;; tell emacs where to read abbrev
      "~/.emacs.d/.abbrev_defs");; definitions from...
(setq save-abbrevs t);; save abbrevs when files are saved
(quietly-read-abbrev-file);; reads the abbreviations file on startup


;快速标示类似isearch
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
(add-to-list 'load-path "~/.emacs.d/yasnippet-20130722.1832")
(require 'yasnippet)
(yas-global-mode 1)

;;projectile-mode
(projectile-global-mode)
;;org-pomodoro
(require 'org-pomodoro)

;;org-mode config


;;skewer
(require 'skewer-coffee)


;;web-mode
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.blade.php\\'" . web-mode))

;;hs-minor-mode
(add-hook 'php-mode-hook 'hs-minor-mode)

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



;;将子窗口自动编号,然后按M-0…9跳转
(add-to-list 'load-path "~/.emacs.d/elpa/window-numbering")
(require 'window-numbering )
(window-numbering-mode 1)

;;给相关模式加上括号匹配输入
(autopair-global-mode) ;; enable autopair in all buffers

;;复制一行
(fset 'my-copy-line
   [?\M-m C-tab end ?\M-w])
;;替换一行
(fset 'my-replace-line
   [?\C-a C-tab ?\C-e ?\C-y])

;;复制区域
(fset 'my-copy-domain
   [?\C-= ?\M-w])
;;粘贴区域
(fset 'my-paster-domain
   [?\C-= ?\C-y])

(fset 'my-comment
   [?\M-m C-tab ?\C-e ?\M-\;])
(fset 'my-uncomment
   [?\M-m C-tab ?\C-e ?\M-\;])
(fset 'my-save-all-buffers
   [?\M-x ?s ?a ?v ?e ?- ?s ?o ?m ?e ?- ?b ?u ?f ?f ?e ?r ?s return ?!])
(fset 'my-kill-buffer
   [?\M-x ?k ?i ?l ?l ?- ?b ?u ?f ?f ?e ?r return return])

;;自定义的快捷键
(define-key global-map [f1] 'my-recentf-open)
(define-key global-map [f2] 'my-save-all-buffers)
(define-key global-map [f5] 'call-last-kbd-macro)
(define-key global-map [f10] 'ido-switch-buffer)
(define-key global-map [f12] 'my-kill-buffer)
(define-key global-map [f7] 'my-copy-line)
(define-key global-map [f8] 'my-copy-domain)
(global-set-key (kbd "C-<f8>")  'my-paster-domain)
(global-set-key (kbd "C-<f2>")  'org-pomodoro)
(global-set-key (kbd "C-<f3>")  'bmkp-previous-bookmark-this-file/buffer-repeat)
(global-set-key (kbd "C-<f4>")  'bmkp-next-bookmark-this-file/buffer-repeat)
(global-set-key (kbd "C-<f5>")  'bookmark-bmenu-list)
(global-set-key [f9]  'bmkp-toggle-autonamed-bookmark-set/delete)
(global-set-key (kbd "<M-right>")  'bmkp-next-autonamed-bookmark-repeat)
(global-set-key (kbd "<M-left>")  'bmkp-previous-autonamed-bookmark-repeat)

(global-set-key (kbd "<menu>")  'ace-jump-word-mode)
(global-set-key (kbd "C-.")  'goto-last-change)

(define-key global-map (kbd "C-o") 'projectile-find-file)
(define-key global-map   (kbd "C-'") 'duplicate-line)
(define-key global-map   (kbd "C-\"") 'ace-jump-char-mode)
(define-key global-map  (kbd "C-<up>") 'previous-buffer)
(define-key global-map  (kbd "C-<down>") 'next-buffer)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)
(global-set-key (kbd "C-M-;")  'my-comment)
(global-set-key (kbd "C-M-'")  'my-uncomment)

(global-set-key (kbd "C-c t")  'insert-short-time)
(global-set-key (kbd "C-c d")  'insert-short-day)

;;cider

(define-key global-map   (kbd "C-c C-b") 'cider-load-current-buffer)

;;angularjs
(require 'angular-snippets)
(eval-after-load "sgml-mode"
  '(define-key html-mode-map (kbd "C-c C-d") 'ng-snip-show-docs-at-point))


; 缩进代码折叠
(global-set-key (kbd "C-c f")  'my-toggle-selective-display)
(defun my-toggle-selective-display()
  "set-selective-display to current column or toggle
selective-display --lgfang"
  (interactive)
  (let ((arg (progn (back-to-indentation) (current-column))))
    (set-selective-display (if (eq arg selective-display) nil arg))))
;;bookmark+
(add-to-list 'load-path "~/.emacs.d/elpa/bookmark+-20140904.1610")
(require 'bookmark+)
;;evil

;(add-to-list 'load-path "~/.emacs.d/elpa/evil-20140322.1542")
;; (require 'evil)
;; (evil-mode 1)
;; (setq evil-shift-width 2)
;;evil tabs
;; (global-evil-tabs-mode t)
;; ;;evil surround
;; (global-surround-mode t)
;; ;;evil leader
;; (global-evil-leader-mode t)
;; (evil-leader/set-key "e" 'ido-find-file)

(setq ahk-syntax-directory "/media/main/weiyongqing/wine/AutoHotkey/Extras/Editors/Syntax/")
(add-to-list 'auto-mode-alist '("\\.ahk$" . ahk-mode))
(autoload 'ahk-mode "ahk-mode")

;;dirtree
(autoload 'dirtree "dirtree" "Add directory to tree view" t)

(fset 'my-shell-clear
   [escape ?\C-x ?h ?d ?i])

;;browse angularjs doc
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")


(fset 'my-task-new
   [C-S-return ?\C-w ?\C-w ?* ?* ?* ?  ?\C-c ?t])

(fset 'my-task-finish
   [end home C-right C-right C-right right ?\C-c ?t ?\M-x ?m ?y ?- ?d ?i ?f ?f ?- ?t ?i ?m ?e return])
(fset 'my-task-end
   [?\M-> ?\C-p tab ?\M-> ?\C-p tab ?\M->])
(global-set-key (kbd "C-c e")  'my-task-finish)
(global-set-key (kbd "C-c n")  'my-task-new)
(global-set-key (kbd "C-c <end>")  'my-task-end)

(fset 'gbk-code
   [?\M-x ?r ?e ?v ?e ?r ?t ?- ?b ?u ?f ?f ?e ?r ?- ?w ?i ?t ?h ?- ?c ?o ?d ?i ?n ?g ?- ?s ?y ?s ?t ?e ?m return ?g ?b ?2 ?3 ?1 ?2 ?- ?d ?o ?s return ?y])

(defun my-diff-time ()
  "calc diff time"
  (interactive)
  (let* ((t2 (buffer-substring (point) (- (point) 9)))
         (t1 (buffer-substring (- (point) 9) (- (point) 18)))
         (t1-list (parse-time-string t1))
         (t1-h (nth 2 t1-list))
         (t1-m (nth 1 t1-list))
         (t2-list (parse-time-string t2))
         (t2-h (nth 2 t2-list))
         (t2-m (nth 1 t2-list))
         (h-diff (- t2-h t1-h))
         (m-diff (- t2-m t1-m))
         (minutes (+ (* h-diff 60) m-diff))
         (h (floor (/ minutes 60)))
         (m (mod minutes 60)))
    (insert-string (concat (number-to-string h) "小时" (number-to-string m) "分钟 "))))

(add-hook 'kill-emacs-hook 'save-current-configuration)
(add-hook 'emacs-startup-hook 'resume)

(add-hook 'kill-emacs-hook  'bmkp-delete-autonamed-no-confirm)

(provide 'init-local)
