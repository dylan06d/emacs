(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)  ;; 没装的包自动安装


;;; 设置主题和ui
(load-file (expand-file-name "ui.el" user-emacs-directory))

;;; 设置代码格式和基础
(load-file (expand-file-name "code.el" user-emacs-directory))

;;; 设置基础补全corfu
(load-file (expand-file-name "corfu.el" user-emacs-directory))

;;; 设置补全
; (load-file (expand-file-name "lspmode.el" user-emacs-directory))

;;; magit
(load-file (expand-file-name "magit.el" user-emacs-directory))

;;; 设置快捷键
(load-file (expand-file-name "keybinds.el" user-emacs-directory))
