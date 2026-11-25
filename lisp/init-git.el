;;; init-git.el --- Magit -*- lexical-binding: t; -*-
;;; =================================================

(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-c g" . magit-dispatch))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1))

(provide 'init-git)
;;; init-git.el ends here
