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
