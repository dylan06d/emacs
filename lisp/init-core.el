;;; init-core.el --- 自动生成文件统一放进缓存目录 -*- lexical-binding: t; -*-
;;; =============================================================================

(defconst my/cache-dir (expand-file-name "~/.emacs-bc/")
  "所有自动生成文件(备份、自动保存、历史等)的存放目录。")
(make-directory my/cache-dir t)

(defun my/cache-file (name)
  "返回缓存目录下名为 NAME 的文件路径,其它模块用它来存自己的数据文件。"
  (expand-file-name name my/cache-dir))

;; 备份文件(file~)
(setq backup-directory-alist `(("." . ,my/cache-dir))
      backup-by-copying t)               ; 复制方式备份,避免硬链接问题

;; 自动保存文件(#file#)及其会话列表
(make-directory (my/cache-file "auto-save-list/") t)
(setq auto-save-file-name-transforms `((".*" ,my/cache-dir t))
      auto-save-list-file-prefix (my/cache-file "auto-save-list/.saves-"))

;; 锁文件(.#file)直接禁用
(setq create-lockfiles nil)

;; Customize 界面的设置
(setq custom-file (my/cache-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;; 最近文件
(setq recentf-save-file (my/cache-file "recentf")
      recentf-max-saved-items 200)
(recentf-mode 1)

;; minibuffer 历史(Corfu 的使用历史也存在这里)
(use-package savehist
  :ensure nil
  :init
  (setq savehist-file (my/cache-file "savehist"))
  (savehist-mode 1))

(provide 'init-core)
;;; init-core.el ends here
