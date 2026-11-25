;;; init-lsp.el --- LSP 与诊断(C / C++;Python 见 init-langs) -*- lexical-binding: t; -*-
;;; =====================================================================================

(use-package lsp-mode
  :init
  ;; LSP 命令统一放在 C-c l 前缀下(按下 C-c l 后 which-key 会列出所有后续键)
  (setq lsp-keymap-prefix "C-c l")
  :hook (((c-mode c++-mode) . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom
  (lsp-enable-indentation nil)            ; TAB 缩进仍用 cc-mode 自己的规则
  (lsp-enable-on-type-formatting nil)     ; 不要打完 `}' 就自动重排
  (lsp-completion-provider :capf)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-auto-guess-root t)                 ; 自动猜测项目根目录
  (lsp-keep-workspace-alive nil)          ; 关闭后不留孤立进程
  (lsp-clients-clangd-args
   '("--header-insertion=never"           ; 不自动插入 #include
     "--background-index")))              ; 后台建索引,不卡编辑

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-delay 0.2))

;; flycheck 负责诊断;LSP 缓冲区里错误文字由 lsp-ui-sideline 显示,
;; 所以不再装 flycheck-pos-tip(否则同一错误会提示两遍)。
(use-package flycheck
  :init (global-flycheck-mode)
  :custom (flycheck-display-errors-delay 0.3)
  :bind (("C-c e" . flycheck-list-errors)
         :map flycheck-mode-map
         ("M-n" . flycheck-next-error)
         ("M-p" . flycheck-previous-error)))

(provide 'init-lsp)
;;; init-lsp.el ends here
