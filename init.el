;;; init.el --- 入口:只负责按顺序加载 lisp/ 下的模块 -*- lexical-binding: t; -*-
;;; ================================================================================

;; 静默 native-comp 的异步警告
(setq native-comp-async-report-warnings-errors 'silent)

(defconst my/lisp-dir (expand-file-name "lisp/" user-emacs-directory)
  "存放各配置模块的目录。")
(add-to-list 'load-path my/lisp-dir)

;; 模块清单:加载顺序就是这里的顺序。新增模块只需在这里加一行。
;; 模块文件统一命名为 init-xxx.el,避免与同名第三方包(如 corfu)冲突。
(defvar my/modules
  '(init-packages     ; 包管理器 + use-package
    init-core         ; 缓存目录、备份、自动保存、savehist、recentf
    init-editing      ; 缩进、C 风格、删除行为、行号、编辑类命令
    init-ui           ; 界面、字体、主题
    init-completion   ; Corfu / Cape / Orderless / ido / smex
    init-lsp          ; lsp-mode / lsp-ui / flycheck
    init-langs        ; 各语言(目前:Python)
    init-keys         ; 通用快捷键(窗口、编译、撤销、which-key)
    init-git)         ; Magit
  "按顺序加载的模块列表。")

(defun my/load-modules ()
  "依次加载 `my/modules'。某个模块出错只告警,不影响其余模块。"
  (dolist (m my/modules)
    (condition-case err
        (load (symbol-name m) nil 'nomessage)
      (error (display-warning 'init
                              (format "模块 %s 加载失败: %s" m (error-message-string err))
                              :error)))))

(defun my/reload-config ()
  "重新加载全部模块(`require' 不会重复加载,所以这里用 `load')。"
  (interactive)
  (my/load-modules)
  (message "✅ Configuration reloaded!"))

(my/load-modules)

;;; init.el ends here
