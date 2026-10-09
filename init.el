(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)  ;; 没装的包自动安装

(setq native-comp-async-report-warnings-errors 'silent)

(defun my-load-directory (dir)
  "加载 DIR 目录下所有未加载的 .el 文件。"
  (dolist (file (directory-files dir t "\\.el$"))
    (load file 'noerror 'nomessage)))

(my-load-directory "~/.config/emacs/lisp/")
