;;; ---- Python ----
;; 需要先安装语言服务器：pipx install pyright（或 npm i -g pyright）
(setq python-indent-offset 4)
(setq python-indent-guess-indent-offset nil)       ; 不自动猜缩进，统一 4 空格
(setq python-shell-interpreter "python3")

;; 虚拟环境：M-x pyvenv-activate 选目录后自动重启 lsp，补全才能识别该环境的包
(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1)
  (add-hook 'pyvenv-post-activate-hooks
            (lambda ()
              (when (bound-and-true-p lsp-mode)
                (lsp-restart-workspace)))))

;; lsp-pyright：补全 / 跳转 / 诊断
(use-package lsp-pyright
  :ensure t
  :init
  ;; 用 basedpyright 的话改成 "basedpyright-langserver"
  (setq lsp-pyright-langserver-command "pyright")
  :custom
  (lsp-pyright-typechecking-mode "basic")          ; "off" / "basic" / "standard" / "strict"
  (lsp-pyright-auto-import-completions t)
  (lsp-pyright-auto-search-paths t)
  (lsp-pyright-use-library-code-for-types t)
  :hook ((python-mode python-ts-mode) . (lambda ()
                                          (require 'lsp-pyright)
                                          (lsp-deferred))))

;; python buffer 里额外加上文件路径补全
(defun my/python-capf-setup ()
  (add-to-list 'completion-at-point-functions #'cape-file t))
(add-hook 'python-mode-hook #'my/python-capf-setup)
(add-hook 'python-ts-mode-hook #'my/python-capf-setup)

;; 快捷键
(with-eval-after-load 'python
  (define-key python-mode-map (kbd "C-c C-p") #'run-python)
  (define-key python-mode-map (kbd "C-c C-v") #'pyvenv-activate))
