;;; init-keys.el --- 通用快捷键(与具体功能无关的) -*- lexical-binding: t; -*-
;;; =============================================================================

;; 约定:和某个功能强相关的键绑定放在该功能所在的模块里。

;;; ---- 编译 / shell ----
(require 'compile)   ; 必须先加载,否则下面 let 绑定的 compile-command 不是动态绑定

(defun my/compile ()
  "编译;minibuffer 里的命令初始为空,历史用 M-p 取。"
  (interactive)
  (let ((compile-command ""))
    (call-interactively #'compile)))

(global-set-key (kbd "C-!") #'my/compile)
(global-set-key (kbd "C-@") #'async-shell-command)   ; 仅图形界面

;;; ---- 撤销 / 重做 ----
(global-set-key (kbd "C-z") #'undo)
(global-set-key (kbd "C-/") #'undo-redo)

;;; ---- 缓冲区 ----
(defun my/kill-other-buffers ()
  "关闭除当前缓冲区之外的所有缓冲区。"
  (interactive)
  (let ((current (current-buffer)))
    (dolist (buf (buffer-list))
      (unless (eq buf current)
        (kill-buffer buf)))))
(global-set-key (kbd "C-c k") #'my/kill-other-buffers)

;;; ---- 窗口布局撤销 / 重做 ----
(setq winner-dont-bind-my-keys t)   ; 不占用默认的 C-c <left>/<right>
(winner-mode 1)
(global-set-key (kbd "C-c c") #'winner-undo)
(global-set-key (kbd "C-c v") #'winner-redo)

;;; ---- 窗口跳转与交换 ----
(require 'windmove)
(global-set-key (kbd "C-c C-<left>")  #'windmove-left)
(global-set-key (kbd "C-c C-<right>") #'windmove-right)
(global-set-key (kbd "C-c C-<up>")    #'windmove-up)
(global-set-key (kbd "C-c C-<down>")  #'windmove-down)
(global-set-key (kbd "C-c M-<left>")  #'windmove-swap-states-left)
(global-set-key (kbd "C-c M-<right>") #'windmove-swap-states-right)
(global-set-key (kbd "C-c M-<up>")    #'windmove-swap-states-up)
(global-set-key (kbd "C-c M-<down>")  #'windmove-swap-states-down)

;;; ---- 重载配置 ----
(global-set-key (kbd "C-c r") #'my/reload-config)   ; 定义在 init.el

;;; ---- 按下前缀键后显示可用的后续键 ----
(use-package which-key
  :config (which-key-mode 1))

(provide 'init-keys)
;;; init-keys.el ends here
