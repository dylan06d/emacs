;;; lsp-mode
(use-package lsp-mode
  :ensure t
  :hook ((c-mode . lsp-deferred)
         (c++-mode . lsp-deferred))
  :init
  ;; 关闭 lsp 接管 indent-region(TAB 缩进仍用 Emacs 自己的 cc-mode 规则)
  (setq lsp-enable-indentation nil)
  ;; 关闭"输入某些字符时自动格式化"(比如打完 `}` 自动重排)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-completion-provider :capf)
  :config
  ;; 只用补全 + 诊断 + 跳转,不要 lsp 的其他花哨 UI
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-modeline-code-actions-enable nil)
  ;; clangd 相关参数
  (setq lsp-clients-clangd-args
        '("--header-insertion=never"      ;; 内核头文件组织特殊,别让它替你猜
          "--background-index"))          ;; 后台建索引,不卡住编辑
  ;; zls 可执行文件路径,不在 PATH 里就写绝对路径
  (setq lsp-zig-zls-executable "zls"))
 
(setq lsp-auto-guess-root t)          ;; 自动猜测根目录,减少询问
(setq lsp-keep-workspace-alive nil)   ;; 关闭 lsp 后不留孤立进程
 
;;; lsp-ui：错误说明 / 侧边提示
(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable t)           ;; 打开右侧提示栏
  (setq lsp-ui-sideline-show-diagnostics t) ;; 显示错误/警告文字
  (setq lsp-ui-sideline-show-hover nil)     ;; 不用它显示 hover 文档,避免太乱
  (setq lsp-ui-sideline-delay 0.2))
 
;;; flycheck：错误说明增强
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :config
  (setq flycheck-display-errors-delay 0.3))
 
(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))
 
(global-set-key (kbd "C-c e") 'flycheck-list-errors)
(global-set-key (kbd "M-n") 'flycheck-next-error)
(global-set-key (kbd "M-p") 'flycheck-previous-error)
