;;; 设置搜索有备选
;; 安装 vertico
(unless (package-installed-p 'vertico)
  (package-refresh-contents)
  (package-install 'vertico))

;; 启用 vertico
(vertico-mode 1)

;; 让 C-x C-f 和 C-x b 使用 vertico 的增强补全
(setq completion-styles '(basic partial-completion flex))

;;; 管理自动生成的文件
;; 1. 定义存放目录
(setq my-emacs-cache-dir (expand-file-name "~/.emacs-bc/"))

;; 2. 创建目录（如果不存在）
(unless (file-directory-p my-emacs-cache-dir)
  (make-directory my-emacs-cache-dir t))

;; 3. 备份文件（~ 文件）
(setq backup-directory-alist
      `(("." . ,my-emacs-cache-dir)))
(setq backup-by-copying t)   ; 复制方式备份，避免硬链接问题

;; 4. 自动保存文件（# 文件）
(setq auto-save-file-name-transforms
      `((".*" ,my-emacs-cache-dir t)))

;; 5. 锁文件（.# 文件）—— Emacs 27+ 支持
(setq create-lockfiles nil)   ; 简单粗暴：直接禁用锁文件
;; 或者如果想也存到缓存目录（需要 Emacs 28+）：
;; (setq lock-file-name-transforms
;;       `((".*" ,my-emacs-cache-dir t)))

;; 6. 自定义文件（custom.el 等）
(setq custom-file (expand-file-name "custom.el" my-emacs-cache-dir))
;; 如果 custom-file 存在则加载
(if (file-exists-p custom-file)
    (load custom-file))

;; 7. 其他杂项：自动保存的会话文件、最近文件列表等
(setq recentf-save-file (expand-file-name "recentf" my-emacs-cache-dir))
(setq savehist-file (expand-file-name "savehist" my-emacs-cache-dir))

;;; 设置缩进
;; 1. 基础缩进宽度（通用）
(setq-default tab-width 4)                    ; Tab 宽度为 4
(setq-default indent-tabs-mode nil)           ; 使用空格代替 Tab
(setq-default c-basic-offset 4)               ; C 类语言缩进 4

;; 2. 设置标准缩进值
(setq standard-indent 4)                      ; 标准缩进为 4

;; 3. 确保所有编程模式使用 4 空格缩进
(setq-default tab-stop-list (number-sequence 4 200 4))  ; Tab 停止位每 4 格

;;; 删除设置
(setq delete-active-region t)
(defun rc/delete-whole-line ()
  "Delete (not kill) the current line."
  (interactive)
  (delete-region (line-beginning-position) (min (point-max) (1+ (line-end-position)))))
(global-set-key (kbd "C-S-<backspace>") 'rc/delete-whole-line)
(defun rc/delete-word-backward (arg)
  "Delete (not kill) characters backward until encountering the beginning of a word."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))
(global-set-key (kbd "C-<backspace>") 'rc/delete-word-backward)
(defun rc/delete-word-forward (arg)
  "Delete (not kill) characters forward until encountering the end of a word."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))
(global-set-key (kbd "M-d") 'rc/delete-word-forward) 

;;; 开启行号
(global-display-line-numbers-mode 1)

;;; 设置缩进风格为Allman
(setq c-default-style '((c-mode . "bsd")
                         (c++-mode . "bsd")
                         (java-mode . "bsd")
                         (awk-mode . "bsd")
                         (other . "bsd")))


;;; 缩进设置
(defun my-dedent-line ()
  "删除当前行的一次缩进。"
  (interactive)
  (save-excursion
    (beginning-of-line)
    ;; 如果行首是 tab，删掉一个 tab
    (if (eq (char-after) ?\t)
        (delete-char 1)
      ;; 否则删掉一个缩进宽度对应的空格
      (let ((n (or (and (boundp 'tab-width) tab-width) 4)))
        (when (looking-at (concat " \\{" (number-to-string n) "\\}"))
          (delete-char n))
        ;; 若不足一个缩进宽度，能删多少删多少
        (when (and (not (eq (char-after) ?\t))
                   (looking-at " +"))
          (delete-region (point)
                         (progn (skip-chars-forward " ")
                                (point))))))))
(defun my-force-indent-line ()
  "强制在当前行行首增加一次缩进，不依赖语法判断。"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (let ((indent (if indent-tabs-mode
                      "\t"
                    (make-string (or tab-width 4) ?\s))))
      (insert indent))))
(global-set-key (kbd "C-c a") 'my-dedent-line)
(global-set-key (kbd "C-c e") 'my-force-indent-line)
