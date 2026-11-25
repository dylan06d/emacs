;;; init-ui.el --- 界面、字体、主题 -*- lexical-binding: t; -*-
;;; ==============================================================

;;; ---- 去掉多余 UI ----
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;; ---- 启动 ----
(setq inhibit-startup-screen t
      initial-scratch-message nil)
;; 不再强制切到 *scratch*:否则 `emacs foo.c' 会被盖掉。
;; 不带文件启动时 Emacs 本来就显示 *scratch*。

;;; ---- 字体与透明度(想改只改这两个变量)----
(defvar my/font "FantasqueSansM Nerd Font-16"
  "默认字体,格式:字体名-字号。字体没装时 Emacs 会悄悄回退。")
(defvar my/alpha-background 100
  "背景不透明度(0-100),只影响背景,文字保持不透明。")

(setf (alist-get 'font default-frame-alist) my/font)
(setf (alist-get 'alpha-background default-frame-alist) my/alpha-background)

;;; ---- 主题 ----
(use-package doom-themes
  :config
  (load-theme 'doom-acario-dark t))

;;; ---- 编译缓冲区显示 ANSI 颜色 ----
(require 'ansi-color)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

(provide 'init-ui)
;;; init-ui.el ends here
