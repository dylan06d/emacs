;;; init-editing.el --- 缩进、删除、编辑类命令 -*- lexical-binding: t; -*-
;;; =========================================================================

;;; ---- 基础 ----
(setq-default tab-width 4
              indent-tabs-mode nil)      ; 用空格代替 Tab
(setq standard-indent 4)

(delete-selection-mode 1)                ; 选区后直接输入会替换选区
(global-display-line-numbers-mode 1)     ; 全局行号

;;; ---- C/C++ 风格:Allman(bsd 基础上固定 4 空格)----
;; 注意:内置 "bsd" 风格的 c-basic-offset 是 8,会覆盖 setq-default,
;; 所以这里基于 bsd 派生一个 4 空格版本。
(with-eval-after-load 'cc-mode
  (c-add-style "my-allman" '("bsd" (c-basic-offset . 4)))
  (setq c-default-style '((other . "my-allman"))))

;;; ---- Makefile 必须用真正的 Tab ----
(defun my/use-tabs ()
  "让当前缓冲区使用真正的 Tab 缩进。"
  (setq indent-tabs-mode t))
(add-hook 'makefile-mode-hook #'my/use-tabs)

;;; ---- 删除(不进 kill ring)----
(defun my/delete-whole-line ()
  "删除(不是剪切)当前整行。"
  (interactive)
  (delete-region (line-beginning-position)
                 (min (point-max) (1+ (line-end-position)))))

(defun my/delete-word-backward (arg)
  "向前删除 ARG 个词(不进 kill ring)。"
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun my/delete-word-forward (arg)
  "向后删除 ARG 个词(不进 kill ring)。"
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(global-set-key (kbd "C-S-<backspace>") #'my/delete-whole-line)
(global-set-key (kbd "C-<backspace>")   #'my/delete-word-backward)
(global-set-key (kbd "M-d")             #'my/delete-word-forward)

;;; ---- 缩进 / 反缩进当前行 ----
(defun my/dedent-line ()
  "当前行减少一级缩进:有 Tab 删一个 Tab,否则最多删 `tab-width' 个空格。"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (if (eq (char-after) ?\t)
        (delete-char 1)
      (let ((spaces (save-excursion (skip-chars-forward " "))))
        (delete-char (min spaces tab-width))))))

(defun my/force-indent-line ()
  "强制在行首增加一级缩进,不看语法。"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (insert (if indent-tabs-mode "\t" (make-string tab-width ?\s)))))

(global-set-key (kbd "C-c a") #'my/dedent-line)
(global-set-key (kbd "C-c E") #'my/force-indent-line)

;;; ---- 开新行 ----
(defun my/open-line-above ()
  "在当前行上方插入空行,光标留在原来的文字上。"
  (interactive)
  (save-excursion
    (beginning-of-line)
    (open-line 1)))

(global-set-key (kbd "C-<return>")   #'open-line)           ; 光标处开空行,光标不动
(global-set-key (kbd "C-S-<return>") #'my/open-line-above)

;;; ---- 移动 / 补全小工具 ----
(global-set-key (kbd "C-a") #'back-to-indentation)
(global-set-key (kbd "C-n") #'dabbrev-expand)               ; 原版 M-/ 仍可用

(use-package move-text
  :bind (("M-<up>"   . move-text-up)
         ("M-<down>" . move-text-down)))

(provide 'init-editing)
;;; init-editing.el ends here
