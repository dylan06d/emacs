;;; early-init.el --- 在 package.el 自动初始化之前执行 -*- lexical-binding: t; -*-

;; Emacs 27+ 会在加载 init.el 之前自动执行 early-init.el,并且会在此之后、
;; init.el 之前用默认的 package-user-dir 自动激活已安装的包。
;; 必须在这里(而不是 init.el 里)提前重定向 ELPA 目录和原生编译缓存,
;; 否则设置为时已晚,包仍会被激活自默认的 ~/.emacs.d/elpa。

(defvar my-emacs-bc-dir (expand-file-name "~/.emacs-bc/")
  "存放所有非配置类自动生成文件的目录。")
(unless (file-directory-p my-emacs-bc-dir)
  (make-directory my-emacs-bc-dir t))

;; ELPA 包安装目录
(setq package-user-dir (expand-file-name "elpa" my-emacs-bc-dir))

;; 原生编译缓存目录(Emacs 28+ 的 native-comp,.eln 文件)
(when (fboundp 'startup-redirect-eln-cache)
  (startup-redirect-eln-cache (expand-file-name "eln-cache/" my-emacs-bc-dir)))

;; 关闭 Emacs 的自动包激活,改为在 init.el 中手动调用 (package-initialize),
;; 这样才能保证上面对 package-user-dir 的重定向真正生效。
(setq package-enable-at-startup nil)
