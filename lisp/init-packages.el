;;; init-packages.el --- 包管理器与 use-package -*- lexical-binding: t; -*-
;;; ========================================================================

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; 首次启动(没有索引缓存)时刷新一次
(unless package-archive-contents
  (package-refresh-contents))

;; Emacs 29+ 自带 use-package;旧版本在这里补装
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; 所有 use-package 默认自动安装;内置库要写 :ensure nil
(setq use-package-always-ensure t)

(provide 'init-packages)
;;; init-packages.el ends here
