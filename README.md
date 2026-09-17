# emacs

> 简洁快速的 Emacs 配置

一份轻量、开箱即用的 Emacs 配置,基于 `use-package` 管理插件,搭配 [Corfu](https://github.com/minad/corfu) + [Vertico](https://github.com/minad/vertico) + [Orderless](https://github.com/oantolin/orderless) + [Consult](https://github.com/minad/consult) 打造现代化的补全与查找体验,并内置一套顺手的自定义快捷键。

## 特性

- **极简界面**:启动时关闭菜单栏、工具栏、滚动条,不显示启动画面,直接进入空白的 `*scratch*` 缓冲区。
- **现代补全栈**:
  - [Corfu](https://github.com/minad/corfu) —— 内联补全弹窗
  - [Cape](https://github.com/minad/cape) —— 补充 `dabbrev` / 文件路径 / 关键字等补全来源
  - [Vertico](https://github.com/minad/vertico) —— minibuffer 候选列表(替代 ido)
  - [Orderless](https://github.com/oantolin/orderless) —— 无序模糊匹配
  - [Marginalia](https://github.com/minad/marginalia) —— 候选项附加说明信息
  - [Consult](https://github.com/minad/consult) —— 增强版查找 / 切换 / ripgrep 搜索
  - [lsp-mod](https://github.com/emacs-lsp/lsp-mode) -- C/C++使用lsp-mod 
- **主题**:默认加载 [doom-themes](https://github.com/doomemacs/themes) 的 `doom-acario-dark`,配置中也保留了切换到 `zenburn` 的注释示例(可自定义背景色)。
- **窗口管理**:内置 `winner-mode`,支持撤销/重做窗口布局,以及自定义窗口交换快捷键。
- **整洁的缓存目录**:备份文件、自动保存文件、锁文件、`custom.el`、`recentf`、`savehist` 等自动生成文件统一收纳到 `~/.emacs-bc/`,不污染项目和主目录。
- **合理的缩进 & 编辑习惯**:默认 4 空格缩进(不使用 Tab),C 系语言使用 BSD/Allman 风格;支持整行/整词的"删除而非剪切"操作。
- **ANSI 颜色支持**:`compilation` 缓冲区自动解析 ANSI 转义序列。
- **行号**:全局开启 `display-line-numbers-mode`。

## 依赖

- Emacs **27+**(建议 28 及以上,以获得更完整的锁文件等特性支持)
- 网络连接(首次启动会自动从 [MELPA](https://melpa.org/) 拉取并安装缺失的包)
- [ripgrep](https://github.com/BurntSushi/ripgrep)(用于 `consult-ripgrep`)

  ```bash
  # Debian / Ubuntu
  sudo apt install ripgrep

  # macOS
  brew install ripgrep
  ```

- 字体:配置默认使用 `Fantasque Sans Mono`(注释中也保留了 Nerd Font 版本的写法),请提前安装,或按需替换 `init.el` 中的 `default-frame-alist` 字体设置。

## 安装

1. 备份现有配置(如果有的话):

   ```bash
   mv ~/.emacs.d ~/.emacs.d.bak
   ```

2. 克隆本仓库到 `~/.emacs.d`:

   ```bash
   git clone https://github.com/dylan06d/emacs.git ~/.emacs.d
   ```

3. 启动 Emacs,首次启动会自动初始化 `package.el`、拉取 MELPA 源并安装所有缺失的包(`use-package`、`doom-themes`、`vertico`、`corfu`、`cape`、`orderless`、`marginalia`、`consult` 等),请保持网络畅通,耐心等待安装完成。

## 目录结构

```
.
├── init.el        # 主配置文件:UI、主题、补全、缩进、缓存目录等
├── keybinds.el     # 自定义快捷键(由 init.el 末尾自动加载)
└── .gitignore
```

## 常用快捷键

| 按键 | 功能 |
| --- | --- |
| `C-!` | 执行 `compile`(每次调用会清空上次的编译命令) |
| `C-@` | 异步执行 shell 命令(`async-shell-command`) |
| `C-c r` | 重新加载 `init.el` 与 `keybinds.el`,并重新启用当前主题 |
| `C-z` | 撤销(`undo`) |
| `C-/` | 重做(`undo-redo`) |
| `C-n` | 触发 `dabbrev-expand` |
| `C-c k` | 关闭除当前 buffer 外的所有 buffer |
| `C-c <left/right/up/down>` | 按方向切换窗口(`windmove`) |
| `C-c w <left/right/up/down>` | 与指定方向的窗口交换位置 |
| `C-S-<backspace>` | 删除(非剪切)整行 |
| `C-<backspace>` | 向后删除(非剪切)一个词 |
| `M-d` | 向前删除(非剪切)一个词 |
| `C-c c` / `C-c v` | `winner-undo` / `winner-redo`,撤销/恢复窗口布局 |
| `C-x b` | `consult-buffer`,增强版缓冲区切换 |
| `C-s` | `consult-line`,当前 buffer 内搜索 |
| `M-y` | `consult-yank-pop`,增强版粘贴历史 |
| `C-c h t` | `consult-find` |
| `C-c h g g` | `consult-ripgrep`(需要安装 `ripgrep`) |
| `C-c h r` | `consult-recentf`,最近打开的文件 |
| `C-c C-d` | 可以生成.clangd和.clang-format

## 自定义主题

`init.el` 中默认启用的是:

```elisp
(load-theme 'doom-acario-dark t)
```

如果想改用 Zenburn,可以取消对应注释块,并按需覆盖背景色,例如:

```elisp
(unless (package-installed-p 'zenburn-theme)
  (package-refresh-contents)
  (package-install 'zenburn-theme))

(setq zenburn-override-colors-alist '(("zenburn-bg" . "#1a1a1a")))
(load-theme 'zenburn t)
```

## 缓存与自动生成文件

所有 Emacs 自动生成的文件(备份 `~`、自动保存 `#`、锁文件 `.#`、`custom.el`、`recentf`、`savehist`)都会被统一放到:

```
~/.emacs-bc/
```

避免这些文件散落在项目目录或 `~/.emacs.d` 中。

## 贡献

欢迎提 Issue 或 PR 来完善这份配置。
