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
          "--background-index")))         ;; 后台建索引,不卡住编辑
(setq lsp-auto-guess-root t)          ;; 自动猜测根目录,减少询问
(setq lsp-keep-workspace-alive nil)   ;; 关闭 lsp 后不留孤立进程
(setq lsp-headerline-breadcrumb-enable nil)
(setq lsp-modeline-code-actions-enable nil)
;; clangd 相关参数
(setq lsp-clients-clangd-args
      '("--header-insertion=never"
        "--background-index"))
;; zls 可执行文件路径,不在 PATH 里就写绝对路径
(setq lsp-zig-zls-executable "zls")

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable t)          ;; 打开右侧提示栏
  (setq lsp-ui-sideline-show-diagnostics t) ;; 显示错误/警告文字
  (setq lsp-ui-sideline-show-hover nil)     ;; 不用它显示 hover 文档,避免太乱
  (setq lsp-ui-sideline-delay 0.2))

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
