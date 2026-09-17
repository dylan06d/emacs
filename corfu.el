;;; 补全
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
  (global-corfu-mode))

;;; ---- Cape：补充更多补全来源 ----
(use-package cape
  :ensure t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

;;; ---- Vertico：minibuffer 候选列表（替代 ido）----
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
