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
- **多语言 LSP 支持**(基于 [lsp-mode](https://github.com/emacs-lsp/lsp-mode) + [lsp-ui](https://github.com/emacs-lsp/lsp-ui) + [flycheck](https://github.com/flycheck/flycheck)):
  - **C / C++** —— `clangd`,支持一键生成 `.clangd` / `.clang-format`
  - **Rust** —— `rust-analyzer`(配合 [rust-mode](https://github.com/rust-lang/rust-mode) + [cargo.el](https://github.com/kwrooijen/cargo.el))
  - **Go** —— `gopls`(配合 [go-mode](https://github.com/dominikh/go-mode.el),保存时自动 `goimports`/整理 import)
  - **Python** —— `pyright` / `python-lsp-server`(`pylsp`),使用 Emacs 内置 `python-mode`
  - **Java** —— [lsp-java](https://github.com/emacs-lsp/lsp-java),自动下载并管理 Eclipse JDT Language Server(`jdtls`)
  - **JavaScript / TypeScript** —— `typescript-language-server`(配合内置 `js-mode` 与 [typescript-mode](https://github.com/emacs-typescript/typescript.el))
  - **PHP** —— `intelephense` / `phpactor`(配合 [php-mode](https://github.com/emacs-php/php-mode))
  - **HTML / CSS** —— `vscode-html-language-server` / `vscode-css-language-server`(使用内置 `mhtml-mode` / `css-mode`)
  - **Make** —— 内置 `makefile-mode`,保留 Tab 缩进(Makefile 语法要求)
  - **CMake** —— `cmake-language-server`(配合 [cmake-mode](https://github.com/emacs-mirror/cmake-mode) + `cmake-font-lock`)
  - **Nix** —— `nixd`(配合 [nix-mode](https://github.com/NixOS/nix-mode),找不到 `nixd` 时可退回 `nil`/`rnix-lsp`)
  - **Zig** —— `zls`(配合 [zig-mode](https://github.com/ziglang/zig-mode))
- **主题**:默认加载 [doom-themes](https://github.com/doomemacs/themes) 的 `doom-acario-dark`,配置中也保留了切换到 `zenburn` 的注释示例(可自定义背景色)。
- **窗口管理**:内置 `winner-mode`,支持撤销/重做窗口布局,以及自定义窗口交换快捷键。
- **整洁的缓存目录**:除本仓库的配置文件外,其余一切自动生成的内容——已安装的 ELPA 包、原生编译缓存(`eln-cache`)、备份文件、自动保存文件、锁文件、`custom.el`、`recentf`、`savehist`,以及 [no-littering](https://github.com/emacscollective/no-littering) 接管的 `transient`(Magit 历史)、`tramp`、`eshell`、`bookmark`、`url` 缓存等——统一收纳到 `~/.emacs-bc/`,不污染 `~/.emacs.d`、项目目录或主目录。
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

### 语言服务器 / 工具链

各语言的补全、跳转、诊断均由对应的语言服务器提供,`lsp-mode` 不会替你安装编译器 / 运行时本身,请按需提前装好:

| 语言 | 语言服务器 | 安装方式(示例) |
| --- | --- | --- |
| C / C++ | `clangd` | `sudo apt install clangd` / `brew install llvm` |
| Rust | `rust-analyzer` | `rustup component add rust-analyzer` |
| Go | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| Python | `pyright` 或 `pylsp` | `npm i -g pyright` 或 `pip install python-lsp-server` |
| Java | `jdtls`(Eclipse JDT LS) | 无需手动安装,首次打开 `.java` 文件时 `lsp-java` 会自动下载 |
| JavaScript / TypeScript | `typescript-language-server` | `npm i -g typescript typescript-language-server` |
| PHP | `intelephense` 或 `phpactor` | `npm i -g intelephense` |
| HTML / CSS | `vscode-langservers-extracted` | `npm i -g vscode-langservers-extracted` |
| CMake | `cmake-language-server` | `pip install cmake-language-server` |
| Nix | `nixd`(可选 `nil` / `rnix-lsp`) | `nix profile install nixpkgs#nixd` 或按发行版包管理器安装 |
| Make | 无(纯语法/缩进支持,不接语言服务器) | —— |
| Zig | `zls` | 参考 [zls 官方文档](https://github.com/zigtools/zls) 编译或下载,确保在 `PATH` 中 |

安装完成后可执行 `M-x my/check-lang-tools` 快速检查 `rust-analyzer`/`gopls`/`pyright`/`pylsp`/`typescript-language-server`/`intelephense`/`vscode-html-language-server`/`cmake-language-server`/`nixd` 是否已在 `PATH` 中可用(该命令只做检测,不会自动安装)。

## 安装

1. 备份现有配置(如果有的话):

   ```bash
   mv ~/.emacs.d ~/.emacs.d.bak
   ```

2. 克隆本仓库到 `~/.emacs.d`:

   ```bash
   git clone https://github.com/dylan06d/emacs.git ~/.emacs.d
   ```

3. 启动 Emacs,首次启动会自动初始化 `package.el`、拉取 MELPA 源并安装所有缺失的包(`use-package`、`no-littering`、`doom-themes`、`vertico`、`corfu`、`cape`、`orderless`、`marginalia`、`consult`、`lsp-mode`、`lsp-ui`、`flycheck`、`rust-mode`、`cargo`、`go-mode`、`lsp-java`、`typescript-mode`、`php-mode`、`cmake-mode`、`cmake-font-lock`、`nix-mode`、`zig-mode`、`magit` 等),请保持网络畅通,耐心等待安装完成。首次打开 `.java` 文件时,`lsp-java` 还会额外下载 `jdtls`,请保持网络畅通。

4. 字体使用 `fantasque-sans`
debian 使用 `sudo apt install fonts-fantasque-sans` 命令安装,且在 `ui.el`下修改字体为
``` lisp
(add-to-list 'default-frame-alist
              '(font . "Fantasque Sans Mono-16:weight=bold"))
```
nixos `nix-shell -p nerd-fonts.fantasque-sans-mono` `nix-shell -p fantasque-sans-mono` ,且在 `ui.el`文件中修改字体为
```lisp
(add-to-list 'default-frame-alist
              '(font . "FantasqueSansM Nerd Font-16:weight=bold"))
```

## 目录结构

```
.
├── early-init.el  # 提前重定向 ELPA 包目录 / 原生编译缓存到 ~/.emacs-bc/(须在 init.el 之前加载)
├── init.el        # 入口文件:初始化 package.el / use-package / no-littering,加载 lisp/ 目录下所有配置
├── ui.el          # UI 设置:关闭菜单栏/工具栏/滚动条、主题、字体、ANSI 颜色
├── code.el        # 编辑基础设置:补全样式、缓存目录、缩进风格、删除行为、行号
├── corfu.el       # 补全栈:Corfu / Cape / Vertico / Orderless / Marginalia / Consult
├── lspmode.el     # LSP 基础设置:lsp-mode / lsp-ui / flycheck,以及 C/C++、Zig 语言配置
├── langs.el       # 多语言支持:Rust / Go / Python / Java / JS/TS / PHP / HTML/CSS / Make / CMake / Nix
├── magit.el       # Magit(Git 客户端)
├── keybinds.el    # 自定义快捷键(含一键重载配置命令)
└── .gitignore
```

> `early-init.el` 与 `init.el` 需位于 `user-emacs-directory` 根目录下,其余文件默认存放于 `~/.config/emacs/lisp/`,由 `init.el` 中的 `my-load-directory` 自动加载。

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
| `M-x my/check-lang-tools` | 检查 Rust / Go / Python 语言服务器是否已在 PATH 中可用

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

除了本仓库里手写的配置文件(`init.el` / `ui.el` / `code.el` / `corfu.el` / `lspmode.el` / `langs.el` / `magit.el` / `keybinds.el`),其余一切由 Emacs 或插件自动生成的内容都会被统一收纳到:

```
~/.emacs-bc/
```

具体包括:

- **ELPA 包安装目录**(`package-user-dir`)—— 不再散落到 `~/.emacs.d/elpa`
- **原生编译缓存**(`eln-cache`,Emacs 28+ 的 native-comp `.eln` 文件)
- **Emacs 内建自动生成文件**:备份 `~`、自动保存 `#`、锁文件 `.#`、`custom.el`、`recentf`、`savehist`
- **其余插件产生的缓存/历史文件**:由 [no-littering](https://github.com/emacscollective/no-littering) 统一接管并重定向到同一目录下,例如 `transient`(Magit 的操作历史)、`tramp`、`eshell` 历史、`bookmark`、`url` 缓存等

前两项与 Emacs 内建部分在 `init.el` / `code.el` 中显式设置,其余交由 `no-littering` 自动处理,新增的插件如果也会写缓存文件,一般无需额外配置即可自动落到 `~/.emacs-bc/` 下的对应子目录中。

避免这些文件散落在项目目录或 `~/.emacs.d` 中。

## 贡献

欢迎提 Issue 或 PR 来完善这份配置。
