;;; init-langs.el --- 各语言配置(目前:Python)-*- lexical-binding: t; -*-
;;; ======================================================================

;; 新增语言:在本文件追加一个小节,LSP 相关写法参考 Python。

;;; ================= Python =================
(defun my/python-lsp-start ()
  "加载 lsp-pyright 并启动 LSP。"
  (require 'lsp-pyright)
  (lsp-deferred))

(defun my/python-restart-lsp ()
  "切换虚拟环境后重启当前 LSP,让 pyright 用新环境。"
  (when (and (bound-and-true-p lsp-mode) (lsp-workspaces))
    (lsp-workspace-restart (car (lsp-workspaces)))))

(use-package python
  :ensure nil
  :custom
  (python-indent-offset 4)
  (python-shell-interpreter "python3")
  :bind (:map python-mode-map
              ("C-c C-v" . pyvenv-activate)))   ; 覆盖原版 python-check

(use-package pyvenv
  :commands (pyvenv-activate pyvenv-deactivate)
  :config
  (add-hook 'pyvenv-post-activate-hooks #'my/python-restart-lsp))

(use-package lsp-pyright
  :defer t
  :hook (python-mode . my/python-lsp-start))

;; 保存时用 black 格式化(需要 pipx install black)
(use-package blacken
  :hook (python-mode . blacken-mode))

;; 跑测试:C-c p t 打开 pytest 菜单(需要项目里装了 pytest)
(use-package python-pytest
  :bind (:map python-mode-map
              ("C-c p t" . python-pytest-dispatch)))

;; 可选:用 IPython 当 REPL(需要 pipx install ipython)
(setq python-shell-interpreter "ipython"
      python-shell-interpreter-args "-i --simple-prompt")

(provide 'init-langs)
;;; init-langs.el ends here
