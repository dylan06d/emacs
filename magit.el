(use-package magit
  :ensure t
  :bind
  (("C-x g" . magit-status)
   ("C-c g" . magit-dispatch))
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1))
