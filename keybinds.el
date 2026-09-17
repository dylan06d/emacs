;;; 设置 C-! 为 compile，且每次都清空输入
(global-set-key (kbd "C-!") 
                (lambda ()
                  (interactive)
                  (let ((compile-command ""))
                    (call-interactively 'compile))))
;;; 设置async
(global-set-key (kbd "C-@") 'async-shell-command)

;;; 极简重新加载配置
(defun my-reload-config ()
  "Reload init.el and keybinds.el."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (load-file (expand-file-name "ui.el" user-emacs-directory))
  (load-file (expand-file-name "code.el" user-emacs-directory))
  (load-file (expand-file-name "corfu.el" user-emacs-directory))
  (load-file (expand-file-name "lspmode.el" user-emacs-directory))
  (load-file (expand-file-name "magit.el" user-emacs-directory))
  (load-file (expand-file-name "keybinds.el" user-emacs-directory))
  (mapc #'enable-theme custom-enabled-themes)
  (message "✅ Configuration reloaded!"))

(global-set-key (kbd "C-c r") 'my-reload-config)

;;; 回撤
;; C-z 为撤销（undo）
(global-set-key (kbd "C-z") 'undo)

;; C-/ 为重做（undo-redo）
(global-set-key (kbd "C-/") 'undo-redo)

;;; 交换C-n和M-/
(global-set-key (kbd "C-n") 'dabbrev-expand)

;;; 关闭除当前 buffer 之外的所有 buffer
(defun kill-other-buffers ()
  "关闭除当前 buffer 之外的所有 buffer。"
  (interactive)
  (let ((current (current-buffer)))
    (mapc (lambda (buf)
            (when (and (buffer-live-p buf)
                       (not (eq buf current)))
              (kill-buffer buf)))
          (buffer-list))))
(global-set-key (kbd "C-c k") 'kill-other-buffers)

;;; 窗口恢复
(winner-mode 1)
(global-set-key (kbd "C-c c") 'winner-undo)
(global-set-key (kbd "C-c v") 'winner-redo)

;;; 更可靠的绑定方式（如果 windmove 不工作）
(define-key winner-mode-map (kbd "C-c <left>") nil)
(define-key winner-mode-map (kbd "C-c <right>") nil)
(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;;; 窗口交换
(require 'windmove)

;; 窗口交换交换函数
(defun my-swap-windows (dir)
  "Swap current window with window in direction DIR."
  (let ((other-window (windmove-find-other-window dir)))
    (when other-window
      (window-swap-states (selected-window) other-window))))

;; 绑定快捷键：C-c + 方向键 交换窗口
(global-set-key (kbd "C-c w <left>")  (lambda () (interactive) (my-swap-windows 'left)))
(global-set-key (kbd "C-c w <right>") (lambda () (interactive) (my-swap-windows 'right)))
(global-set-key (kbd "C-c w <up>")    (lambda () (interactive) (my-swap-windows 'up)))
(global-set-key (kbd "C-c w <down>")  (lambda () (interactive) (my-swap-windows 'down)))

;;; 跳转
(global-set-key (kbd "C-a") 'back-to-indentation)

;;; move-text
(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-<up>") 'move-text-up)
  (global-set-key (kbd "M-<down>") 'move-text-down))

;;; 创建新行
(defun my-open-line ()
  "在当前行上方插入一个空行，光标位置保持不变。"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (open-line 1)
    (indent-according-to-mode)))
(global-set-key (kbd "C-S-<return>") 'my-open-line)
(global-set-key (kbd "C-<return>") 'open-line)
