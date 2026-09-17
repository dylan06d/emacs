;;; ==========================
;; 补全

;;; ---- savehist：记住历史,给 corfu-history 用 ----
(use-package savehist
  :init
  (savehist-mode))
 
;;; ---- Corfu：补全弹窗 ----
(use-package corfu
  :ensure t
  :custom
  (corfu-auto t)
  (corfu-auto-prefix 1)
  (corfu-auto-delay 0.1)
  (corfu-cycle t)
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode)
  :config
  ;; 记住使用历史,让常用词优先排前面
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (corfu-history-mode 1))
 
;;; ---- Cape：补充更多补全来源 ----
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))
 
;; 在 lsp buffer 里,dabbrev 排前面,lsp-completion-at-point 排后面
(defun my/lsp-capf-setup ()
  (setq-local completion-at-point-functions
              (list (cape-capf-super
                     #'cape-dabbrev
                     #'lsp-completion-at-point))))
 
(add-hook 'lsp-completion-mode-hook #'my/lsp-capf-setup)
 
;;; ---- Vertico：minibuffer 候选列表(替代 ido)----
(use-package vertico
  :ensure t
  :init
  (vertico-mode))
 
;;; ---- Orderless：更智能的模糊匹配 ----
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))
 
;;; ---- Marginalia：候选项加说明信息 ----
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))
 
;;; ---- Consult：增强查找/切换命令 ----
(use-package consult
  :ensure t
  :bind (("C-c h t" . consult-find)
         ("C-c h g g" . consult-ripgrep)   ;; 需要 apt install ripgrep
         ("C-c h r" . consult-recentf)
         ("C-x b" . consult-buffer)
         ("M-y" . consult-yank-pop)
         ("C-s" . consult-line)))
 
