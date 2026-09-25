;;; ==========================
;;; lsp


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
 
;;; zig-mode
(use-package zig-mode
  :ensure t
  :hook (zig-mode . lsp-deferred)
  :config
  ;; zig-mode 自带保存时自动 zig fmt,如果你想用自己的格式化流程可以关掉
  (setq zig-format-on-save nil))
 
;;; .clangd .clang-format
(defun clangd-setup ()
  "在当前目录生成两个独立文件:
.clangd —— 只包含 CompileFlags/Index 配置,Add 下面留空模板(自己填 include/define/target)
.clang-format —— 独立的 BSD/Allman 格式化风格文件
不生成 compile_commands.json,不建 .emacs 子目录。"
  (interactive)
  (let* ((root (expand-file-name default-directory))
         (clangd-file (expand-file-name ".clangd" root))
         (clang-format-file (expand-file-name ".clang-format" root))
         (clangd-content
          "CompileFlags:
  Add:
    # - -I/
    # - -D__KERNEL__
    # - -DMODULE
    # - --target=内核
  # Compiler: /usr/bin/gcc
Index:
  Background: Build
")
         (clang-format-content
          "BasedOnStyle: LLVM
BreakBeforeBraces: Allman
IndentWidth: 4
TabWidth: 4
UseTab: Never
AllowShortIfStatementsOnASingleLine: false
AllowShortBlocksOnASingleLine: false
ColumnLimit: 100
"))
    (dolist (pair (list (cons clangd-file clangd-content)
                         (cons clang-format-file clang-format-content)))
      (let ((file (car pair))
            (content (cdr pair)))
        (if (file-exists-p file)
            (if (yes-or-no-p (format "%s 已存在,是否覆盖? " file))
                (progn
                  (with-temp-file file (insert content))
                  (message "✅ 已覆盖写入:%s" file))
              (message "已取消,未修改:%s" file))
          (with-temp-file file (insert content))
          (message "✅ 已生成:%s" file))))))
 
(global-set-key (kbd "C-c C-d") 'clangd-setup)
 
;;; zls.json
(defun zls-setup ()
  "在当前目录生成 zls.json 配置模板。"
  (interactive)
  (let* ((root (expand-file-name default-directory))
         (zls-file (expand-file-name "zls.json" root))
         (zls-content
          "{
  \"enable_snippets\": true,
  \"enable_argument_placeholders\": true,
  \"warn_style\": false,
  \"enable_semantic_tokens\": true,
  \"enable_inlay_hints\": true
}
"))
    (if (file-exists-p zls-file)
        (if (yes-or-no-p (format "%s 已存在,是否覆盖? " zls-file))
            (progn
              (with-temp-file zls-file (insert zls-content))
              (message "✅ 已覆盖写入:%s" zls-file))
          (message "已取消,未修改:%s" zls-file))
      (with-temp-file zls-file (insert zls-content))
      (message "✅ 已生成:%s" zls-file))))
 
(global-set-key (kbd "C-c C-z") 'zls-setup)
 
;;; .clang-format生效
(defun my-c-sync-indent-from-clang-format ()
  "如果当前是 C/C++ mode 且项目里有 .clang-format,
读取其 IndentWidth 并覆盖 c-basic-offset。"
  (interactive)
  (when (derived-mode-p 'c-mode 'c++-mode)
    (when-let* ((dir (locate-dominating-file default-directory ".clang-format"))
                (cf-file (expand-file-name ".clang-format" dir)))
      (let ((width nil))
        ;; 第一步:只在临时缓冲区里读数值,不在这里做任何 setq-local
        (with-temp-buffer
          (insert-file-contents cf-file)
          (goto-char (point-min))
          (when (re-search-forward "^IndentWidth:\\s-*\\([0-9]+\\)" nil t)
            (setq width (string-to-number (match-string 1)))))
        ;; 第二步:跳出 with-temp-buffer 之后,current-buffer 已经变回原来的 .h 文件
        ;; 这里赋值才是正确的目标 buffer
        (when width
          (setq-local c-basic-offset width)
          (setq-local tab-width width)
          (setq-local standard-indent width)
          (message "✅ 缩进已同步为 %d(来自 %s)" width cf-file))))))
 
(add-hook 'hack-local-variables-hook #'my-c-sync-indent-from-clang-format t)

;;; 多语言支持:Rust / Java / Python / Go

;;; ---- Rust ----
(use-package rust-mode
  :ensure t
  :hook (rust-mode . lsp-deferred)
  :config
  ;; 使用 rust-analyzer 作为语言服务器(需在 PATH 中可用)
  (setq rust-mode-treat-dollar-as-punctuation t))

;; cargo 命令集成(build / run / test 等)
(use-package cargo
  :ensure t
  :hook (rust-mode . cargo-minor-mode))

;;; ---- Python ----
;; python-mode 为 Emacs 内置,这里只补充 lsp 挂载与保存时格式化
(add-hook 'python-mode-hook #'lsp-deferred)

;; lsp-mode 默认按 lsp-pyright > pylsp > pyls 顺序寻找已安装的服务器
;; 如需更完整的类型检查体验,建议安装 lsp-pyright:
;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda () (require 'lsp-pyright) (lsp-deferred))))

;;; ---- Go ----
(use-package go-mode
  :ensure t
  :hook (go-mode . lsp-deferred)
  :config
  ;; 保存时自动 goimports/gofmt 并整理 import
  (add-hook 'before-save-hook #'lsp-format-buffer nil t)
  (add-hook 'before-save-hook #'lsp-organize-imports nil t))

;;; ---- Java ----
(use-package lsp-java
  :ensure t
  :hook (java-mode . lsp-deferred)
  :init
  ;; 首次启动会自动下载 Eclipse JDT Language Server(jdtls)
  (setq lsp-java-vmargs
        '("-XX:+UseParallelGC"
          "-XX:GCTimeRatio=4"
          "-XX:AdaptiveSizePolicyWeight=90"
          "-Dsun.zip.disableMemoryMapping=true"
          "-Xmx1G"
          "-Xms100m")))


;;; ---- JavaScript / TypeScript ----
;; 使用内置 js-mode 处理 .js,语言服务器为 typescript-language-server
(add-hook 'js-mode-hook #'lsp-deferred)
 
;; typescript-mode 提供 .ts / .tsx 语法支持
(use-package typescript-mode
  :ensure t
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))
 
;;; ---- PHP ----
(use-package php-mode
  :ensure t
  :hook (php-mode . lsp-deferred))
 
;;; ---- HTML / CSS ----
;; 内置 mhtml-mode / css-mode,语言服务器由 vscode-langservers-extracted 提供
(add-hook 'mhtml-mode-hook #'lsp-deferred)
(add-hook 'css-mode-hook #'lsp-deferred)
 
;;; ---- Make ----
;; 内置 makefile-mode,Makefile 本身不需要缩进转换,确保 Tab 缩进不被替换为空格
(add-hook 'makefile-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)))
 
;;; ---- CMake ----
(use-package cmake-mode
  :ensure t
  :hook (cmake-mode . lsp-deferred))
 
;; CMakeLists.txt / *.cmake 保存时对齐格式(可选,依赖 cmake-format 可执行文件)
(use-package cmake-font-lock
  :ensure t
  :after cmake-mode
  :hook (cmake-mode . cmake-font-lock-activate))

;;; ---- 语言服务器自检提示 ----
;; 只是一个方便的辅助命令,启动后检查常用语言服务器 / 工具链是否在 PATH 中,
;; 缺失时给出提示(不会自动安装,安装方式请参考 README)。
(defun my/check-lang-tools ()
  "检查各语言常用语言服务器是否在 PATH 中可用(仅检测,不自动安装)。"
  (interactive)
  (let* ((checks '(("rust-analyzer" . "rust-analyzer")
                    ("gopls" . "gopls")
                    ("pyright-langserver" . "pyright(可选,pylsp 亦可)")
                    ("pylsp" . "python-lsp-server(可选)")
                    ("typescript-language-server" . "typescript-language-server(JS/TS)")
                    ("intelephense" . "intelephense(PHP,可选,phpactor 亦可)")
                    ("vscode-html-language-server" . "vscode-langservers-extracted(HTML/CSS)")
                    ("cmake-language-server" . "cmake-language-server")))
         (missing (seq-filter
                   (lambda (c) (not (executable-find (car c))))
                   checks)))
    (if missing
        (message "⚠️ 未在 PATH 中找到:%s"
                 (mapconcat (lambda (c) (cdr c)) missing ", "))
      (message "✅ 常用语言工具链均已就绪"))))
