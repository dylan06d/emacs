;;; init-completion.el --- 两套补全:ido(minibuffer)+ Corfu(光标处弹窗) -*- lexical-binding: t; -*-
;;; =================================================================================================

;;; ================= Corfu 弹窗 =================
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.1)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :bind (:map corfu-map
              ("TAB"     . corfu-next)
              ([tab]     . corfu-next)
              ("S-TAB"   . corfu-previous)
              ([backtab] . corfu-previous))
  :init
  (global-corfu-mode)
  :config
  ;; 记住使用历史,常用项排前面(历史由 savehist 保存)
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (corfu-history-mode 1))

;;; ================= Cape 补充来源 =================
(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;; LSP 缓冲区:dabbrev(缓冲区已有词)排前,LSP 排后,另外补全文件路径
(defun my/lsp-capf-setup ()
  "在 LSP 缓冲区里组合 dabbrev + LSP + 文件路径补全。"
  (when (bound-and-true-p lsp-completion-mode)
    (setq-local completion-at-point-functions
                (list (cape-capf-super #'cape-dabbrev #'lsp-completion-at-point)
                      #'cape-file))))
(add-hook 'lsp-completion-mode-hook #'my/lsp-capf-setup)

;;; ================= Orderless 匹配 =================
;; 影响 completion-at-point(Corfu)等内置补全;ido 不受影响
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;; ================= ido + smex(Tsoding 风格横向候选)=================
(use-package ido
  :ensure nil
  :init
  (setq ido-save-directory-list-file (my/cache-file "ido.last"))
  :config
  (ido-mode 1)
  (ido-everywhere 1))

(use-package ido-completing-read+
  :after ido
  :config
  (ido-ubiquitous-mode 1))

(use-package smex
  :init
  (setq smex-save-file (my/cache-file "smex-items"))
  :bind (("M-x" . smex)
         ("C-c C-c M-x" . execute-extended-command)))

(provide 'init-completion)
;;; init-completion.el ends here
