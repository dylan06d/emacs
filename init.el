(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)  ;; 没装的包自动安装

;;; 关闭所有 UI 元素 (菜单栏、工具栏、滚动条)
(menu-bar-mode -1)        ; 关闭菜单栏
(tool-bar-mode -1)        ; 关闭工具栏
(scroll-bar-mode -1)      ; 关闭滚动条

;;; 关闭启动画面 (Startup Screen)
(setq inhibit-startup-screen t)

;;;  关闭 "(*scratch* 改动了, 是否保存?)" 的烦人提示
(setq inhibit-startup-message t) ; 同 inhibit-startup-screen，确保生效

;;; 让 scratch 缓冲区默认使用 Lisp Interaction 模式 (但内容留空)
;; 默认就是 Lisp Interaction，无需额外设置，但我们可以指定初始内容为空
(setq initial-scratch-message nil)

;;;  确保启动后显示的缓冲区是 *scratch*
;;    默认 Emacs 在没有指定文件时，如果关闭了启动画面，就会显示 *scratch*
;;    为了绝对保险，显式声明启动后的第一个缓冲区
(setq initial-buffer-choice t)   ; 't' 表示显示 scratch buffer

;;;  (可选) 让 *scratch* 在启动时自动获取焦点，并且隐藏模式行中的一些杂项
(add-hook 'emacs-startup-hook
          (lambda ()
            (switch-to-buffer "*scratch*")
            (delete-other-windows))) ; 保证只有一个窗口显示 scratch

;;; 设置字体
(add-to-list 'default-frame-alist
              '(font . "Fantasque Sans Mono-16:weight=bold"))

;;; 主题和透明度设置
;; ;; 安装 zenburn-theme（如果尚未安装）
;; (unless (package-installed-p 'zenburn-theme)
;;   (package-refresh-contents)
;;   (package-install 'zenburn-theme))

;; (setq zenburn-override-colors-alist '(("zenburn-bg" . "#1a1a1a")))
;; ;; 加载 Zenburn 主题
;; (load-theme 'zenburn t)

;; 1. 确保 MELPA 仓库可用
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; 2. 安装 doom-themes 包（如果还没安装）
(unless (package-installed-p 'doom-themes)
  (package-refresh-contents)
  (package-install 'doom-themes))

;; 3. 加载并启用 doom-acario-dark 主题
(load-theme 'doom-acario-dark t)

;; 仅设置背景透明度，文字保持不透明。80 表示背景 80% 不透明。
(set-frame-parameter nil 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))

;;; 解析 ANSI 转义序列并转换为实际的颜色和样式
(require 'ansi-color)
(add-hook 'compilation-filter-hook 'ansi-color-compilation-filter)

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

;;; 补全
;;; ---- Corfu：补全弹窗 ----
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.1)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode))

;;; ---- Cape：补充更多补全来源 ----
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;;; ---- Vertico：minibuffer 候选列表（替代 ido）----
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;;; ---- Orderless：更智能的模糊匹配 ----
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;; ---- Marginalia：候选项加说明信息 ----
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;;; ---- Consult：增强查找/切换命令 ----
(use-package consult
  :ensure t
  :bind (("C-c h t" . consult-find)
         ("C-c h g g" . consult-ripgrep)   ;; 需要 apt install ripgrep
         ("C-c h r" . consult-recentf)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-s" . consult-line)))

;;; 窗口恢复
(winner-mode 1)
(global-set-key (kbd "C-c c") 'winner-undo)
(global-set-key (kbd "C-c v") 'winner-redo)

;;; 设置快捷键
(load-file (expand-file-name "keybinds.el" user-emacs-directory))

;;; 设置补全
;(load-file (expand-file-name "lspmod.el" user-emacs-directory))
