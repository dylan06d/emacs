# Emacs 配置说明

适用系统：**Ubuntu / Fedora / CachyOS（Arch）**
主要语言：**C / C++ / Python**（LSP 补全）
风格：**ido 横向补全（Tsoding 风格）+ Corfu 弹窗补全 + 原版 `C-s` 搜索**

记号约定：`C-x` = Ctrl+x，`M-x` = Alt+x（Meta），`S-` = Shift，`s-` = Super，`RET` = 回车，`SPC` = 空格，`DEL` = 退格。
`C-x C-f` 表示先按 Ctrl+x，松开后再按 Ctrl+f。

---

## 目录

1. [目录结构](#1-目录结构)
2. [安装](#2-安装)
3. [各配置文件作用](#3-各配置文件作用)
4. [本配置的快捷键](#4-本配置的快捷键)
5. [被本配置覆盖的原版键位](#5-被本配置覆盖的原版键位)
6. [补全系统怎么用](#6-补全系统怎么用)
7. [Emacs 原版常用快捷键](#7-emacs-原版常用快捷键)
8. [Emacs 特性速览](#8-emacs-特性速览)
9. [缓存文件位置](#9-缓存文件位置)
10. [已知问题与修复建议](#10-已知问题与修复建议)

---

## 1. 目录结构

```
~/.config/emacs/
├── init.el              # 入口：配置 MELPA、use-package，并加载 lisp/ 下所有 .el
└── lisp/
    ├── code.el          # 缓存目录、缩进、删除行为、行号
    ├── corfu.el         # 补全：Corfu / Cape / Orderless / ido / smex
    ├── keybinds.el      # 通用快捷键
    ├── langs.el         # 语言配置（目前只有 Python）
    ├── lspmode.el       # lsp-mode / lsp-ui / flycheck（C、C++）
    ├── magit.el         # Git 界面
    └── ui.el            # 界面、字体、主题
```

`init.el` 会按**文件名字母顺序**加载 `lisp/` 下所有 `.el`：
`code → corfu → keybinds → langs → lspmode → magit → ui`。

> **注意**：如果家目录里已经有 `~/.emacs.d` 或 `~/.emacs`，Emacs 会优先使用它们，`~/.config/emacs` 不会生效。
> 先备份：`mv ~/.emacs.d ~/.emacs.d.bak`

---

## 2. 安装

### 2.1 需要安装什么

| 类别 | 内容 | 用途 |
|---|---|---|
| Emacs | **29 或更高** | 配置用到 `undo-redo`、`alpha-background`、内置 `use-package` 等 |
| Git | git | Magit |
| C/C++ | gcc、make、clangd、clang-format | 编译（`C-!`）、LSP、格式化 |
| Python | python3、pipx、**pyright** | Python LSP 补全 |
| 字体 | FantasqueSansM Nerd Font | `ui.el` 里指定的字体 |
| 可选 | bear、ripgrep | 给 clangd 生成 `compile_commands.json`、更快的项目内搜索 |

Emacs 内部的包（doom-themes、corfu、cape、orderless、ido-completing-read+、smex、lsp-mode、lsp-ui、flycheck、flycheck-pos-tip、magit、move-text、pyvenv、lsp-pyright）**首次启动时会自动从 MELPA 下载**，不用手动装，但需要联网。

### 2.2 Ubuntu

```bash
sudo apt update
sudo apt install -y emacs git build-essential clangd clang-format \
    python3 python3-pip python3-venv pipx curl xz-utils unzip fontconfig bear

pipx ensurepath
pipx install pyright
```

- **Ubuntu 24.04 及以上**：apt 的 Emacs 版本为 29 或更高，可直接用。
- **Ubuntu 22.04**：apt 里是 Emacs 27，**太旧**。任选其一：
  - `sudo snap install emacs --classic`
  - 使用第三方 PPA（如 `ppa:ubuntuhandbook1/emacs`），然后 `sudo apt install emacs`

### 2.3 Fedora

```bash
sudo dnf install -y emacs git gcc gcc-c++ make clang-tools-extra \
    python3 python3-pip pipx curl xz unzip fontconfig bear

pipx ensurepath
pipx install pyright
```

`clang-tools-extra` 里包含 `clangd` 和 `clang-format`。

### 2.4 CachyOS / Arch

```bash
sudo pacman -Syu
sudo pacman -S --needed emacs git base-devel clang \
    python python-pipx curl xz unzip fontconfig bear ttf-fantasque-nerd

pipx ensurepath
pipx install pyright
```

- Arch 的 `clang` 包里已包含 `clangd` 和 `clang-format`。
- 想在 Wayland 下原生运行，把 `emacs` 换成 `emacs-wayland`（两者**互相冲突**，只装一个）。**不要**装 `emacs-nox`，它没有图形界面。
- `ttf-fantasque-nerd` 已提供字体，可跳过 2.5 节。如果找不到这个包，按 2.5 节手动安装。

### 2.5 安装字体（Ubuntu / Fedora）

`ui.el` 使用 `FantasqueSansM Nerd Font`，系统仓库一般没有，手动安装：

```bash
mkdir -p ~/.local/share/fonts
cd /tmp
curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FantasqueSansMono.tar.xz
tar -xf FantasqueSansMono.tar.xz -C ~/.local/share/fonts
fc-cache -fv

# 检查
fc-list | grep -i "FantasqueSansM Nerd Font"
```

字体没装好时 Emacs **不会报错**，只是悄悄用默认字体。想换字体就改 `ui.el` 里的 `"FantasqueSansM Nerd Font-16"`（`-16` 是字号）。

### 2.6 备选：用 npm 安装 pyright

不想用 pipx 时：

```bash
# Ubuntu: sudo apt install nodejs npm
# Fedora: sudo dnf install nodejs npm
# Arch:   sudo pacman -S nodejs npm
npm install -g pyright --prefix ~/.local
```

### 2.7 放置配置文件

```bash
mkdir -p ~/.config/emacs/lisp
cp init.el ~/.config/emacs/
cp code.el corfu.el keybinds.el langs.el lspmode.el magit.el ui.el ~/.config/emacs/lisp/
```

文件名里如果带 `_1` 之类的后缀（如 `code_1.el`），复制时去掉，保持为 `code.el`、`corfu.el`、`lspmode.el`。

### 2.8 首次启动

```bash
emacs
```

- 第一次会下载十几个包，等待一会儿，期间可能出现编译警告（原生编译的警告已被静默）。
- 如果出现 `Package ... is unavailable` 之类的错误：`M-x package-refresh-contents`，然后**重启 Emacs**。
- 启动后会停在 `*scratch*` 缓冲区。

### 2.9 验证

```bash
emacs --version      # 应 >= 29
clangd --version
pyright --version
git --version
```

**GUI 版 Emacs 找不到 `pyright` 怎么办？**
从桌面图标启动的 Emacs 不一定继承终端里的 `PATH`，`~/.local/bin` 可能不在其中。在 Emacs 里按 `M-:` 输入 `(executable-find "pyright")`，返回 `nil` 就是找不到。解决办法（二选一）：

- 把 `export PATH="$HOME/.local/bin:$PATH"` 写进 `~/.profile`，然后重新登录。
- 在 `init.el` 开头加：
  ```elisp
  (add-to-list 'exec-path (expand-file-name "~/.local/bin"))
  (setenv "PATH" (concat (expand-file-name "~/.local/bin") ":" (getenv "PATH")))
  ```

### 2.10 C/C++ 项目需要 `compile_commands.json`

clangd 靠它知道头文件路径和编译参数：

```bash
# Makefile 项目
bear -- make

# CMake 项目
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
ln -s build/compile_commands.json .
```

---

## 3. 各配置文件作用

| 文件 | 内容 |
|---|---|
| `init.el` | 添加 MELPA 源；没有 `use-package` 就安装；`use-package-always-ensure t`（所有 `use-package` 自动装包）；静默原生编译警告；加载 `lisp/` 下所有文件 |
| `code.el` | 备份/自动保存/`custom.el`/`savehist` 都放到 `~/.emacs-bc/`；禁用锁文件；缩进 4 空格；C/C++ 使用 Allman（bsd）风格；选区后输入会替换选区；删除类命令不进 kill ring；全局行号 |
| `corfu.el` | Corfu 弹窗补全（自动触发）；Cape 补充来源；Orderless 匹配（仅影响 Corfu）；**ido + ido-everywhere + ido-ubiquitous**；**smex** 接管 `M-x` |
| `keybinds.el` | 编译、撤销/重做、窗口操作、移动文本、开新行等快捷键 |
| `langs.el` | Python：4 空格缩进、`python3`、pyvenv 虚拟环境、lsp-pyright |
| `lspmode.el` | lsp-mode（C/C++ 自动启动）、lsp-ui 侧边提示、flycheck 诊断；clangd 参数 `--header-insertion=never --background-index` |
| `magit.el` | Magit，状态页占满整个窗口 |
| `ui.el` | 关闭菜单栏/工具栏/滚动条；关闭启动画面；字体；主题 `doom-acario-dark`；编译缓冲区显示颜色 |

---

## 4. 本配置的快捷键

### 4.1 补全 / 命令 / 搜索

| 键 | 作用 | 说明 |
|---|---|---|
| `M-x` | smex | ido 风格的命令列表，常用命令排前面 |
| `C-c C-c M-x` | 原版 `execute-extended-command` | smex 的后备 |
| `C-x C-f` | 打开文件 | ido 横向候选（见第 6 节） |
| `C-x b` | 切换缓冲区 | ido 横向候选 |
| `C-s` / `C-r` | 原版 isearch | 向前/向后增量搜索 |
| `M-y` | 原版 `yank-pop` | 粘贴后切换更早的剪切内容 |
| `C-n` | `dabbrev-expand` | 根据已有单词补全，连按循环候选 |

### 4.2 编辑

| 键 | 作用 |
|---|---|
| `C-a` | 跳到行首第一个非空白字符 |
| `C-<backspace>` | 向前删一个词（**不进 kill ring**） |
| `M-d` | 向后删一个词（**不进 kill ring**） |
| `C-S-<backspace>` | 删除整行（**不进 kill ring**） |
| `C-<return>` | 在光标处开一个空行（`open-line`，光标不动） |
| `C-S-<return>` | 在当前行**上方**插入空行 |
| `M-<up>` / `M-<down>` | 把当前行（或选区）上移/下移 |
| `C-c a` | 当前行减少一级缩进 |
| `C-c E` | 当前行增加一级缩进（强制，不看语法） |
| `C-z` | 撤销 |
| `C-/` | 重做 |

### 4.3 编译 / 运行

| 键 | 作用 |
|---|---|
| `C-!` | 编译。minibuffer 里命令是**空的**，直接输入如 `make` 回车即可；按 `M-p` 取历史命令 |
| `C-@` | `async-shell-command`，异步执行 shell 命令（仅图形界面可用） |

编译缓冲区里按 `g` 重新编译；用 `M-g n` / `M-g p` 在错误间跳转（见 7.8）。

### 4.4 窗口 / 缓冲区

| 键 | 作用 |
|---|---|
| `C-c <left/right/up/down>` | 光标跳到左/右/上/下方的窗口 |
| `C-c w <left/right/up/down>` | 和左/右/上/下方的窗口**交换内容** |
| `C-c c` | 撤销窗口布局变化（winner-undo） |
| `C-c v` | 重做窗口布局变化（winner-redo） |
| `C-c k` | 关闭除当前缓冲区外的所有缓冲区 |

### 4.5 LSP / 诊断

| 键 | 作用 |
|---|---|
| `C-c e` | 列出当前缓冲区所有错误（flycheck-list-errors） |
| `M-n` / `M-p` | 跳到下一个/上一个错误 |
| `C-c ! n` / `C-c ! p` / `C-c ! l` | flycheck 原生键：下一个/上一个/列表 |
| `M-.` | 跳转到定义（LSP 提供） |
| `M-,` | 跳回跳转前的位置 |
| `M-?` | 查找引用 |
| `C-c l r` | 重启 LSP（见第 10 节，**当前绑定有问题**） |

其它 LSP 功能直接用 `M-x`：

- `lsp-rename`：重命名符号
- `lsp-execute-code-action`：代码操作 / 快速修复
- `lsp-format-buffer`：格式化整个缓冲区
- `lsp-describe-thing-at-point`：查看光标处文档
- `lsp-restart-workspace`：重启语言服务器
- `lsp-describe-session`：查看当前 LSP 会话状态

lsp-mode 默认的快捷键前缀是 `s-l`（Super+l），多数桌面环境会占用 Super，建议用上面的 `M-x` 命令。

### 4.6 Python 专用（仅在 Python 缓冲区）

| 键 | 作用 |
|---|---|
| `C-c C-p` | 启动 Python 交互环境（`run-python`） |
| `C-c C-v` | 选择并激活虚拟环境（`pyvenv-activate`），之后自动重启 LSP |
| `C-c C-z` | 切换到 Python 交互窗口（原版） |
| `C-c C-c` | 把整个缓冲区发给交互环境（原版） |
| `C-c C-r` | 把选区发给交互环境（原版） |
| `C-c C-l` | 加载当前文件到交互环境（原版） |
| `C-c <` / `C-c >` | 选区左移/右移一级缩进（原版） |

> 原版 `C-c C-v`（`python-check`）已被覆盖。

虚拟环境用法：项目里 `python3 -m venv .venv` → 打开 `.py` 文件 → `C-c C-v` → 选择 `.venv` 目录。

### 4.7 Magit（Git）

| 键 | 作用 |
|---|---|
| `C-x g` | 打开 Git 状态页（占满整个窗口） |
| `C-c g` | Magit 命令菜单（dispatch） |

状态页里的常用键：

| 键 | 作用 |
|---|---|
| `TAB` | 展开/折叠当前条目 |
| `s` / `u` | 暂存/取消暂存（光标在文件或 hunk 上） |
| `S` / `U` | 暂存全部/取消全部 |
| `c c` | 提交（写完信息后 `C-c C-c` 确认，`C-c C-k` 放弃） |
| `P p` | 推送 |
| `F p` | 拉取 |
| `b b` | 切换分支 |
| `b c` | 新建分支并切换 |
| `l l` | 查看日志 |
| `d d` | 查看差异 |
| `k` | 丢弃修改（会确认） |
| `z z` | stash |
| `g` | 刷新 |
| `?` | 帮助菜单 |
| `q` | 退出，恢复原窗口布局 |

### 4.8 重载配置

| 键 | 作用 |
|---|---|
| `C-c r` | 重载配置（见第 10 节，**当前实现有问题**） |

---

## 5. 被本配置覆盖的原版键位

下面这些键的原版功能被改掉了，对应的找回方式：

| 键 | 原版功能 | 现在 | 怎么用回原版 |
|---|---|---|---|
| `C-n` | 下一行 | `dabbrev-expand` | 用方向键 `↓` |
| `C-a` | 行首 | 行首第一个非空白字符 | `Home` 键 |
| `C-z` | 挂起 Emacs | 撤销 | `C-x C-z`（图形界面下用不上） |
| `C-/` | 撤销 | 重做 | `C-_` 或 `C-x u` 撤销 |
| `M-d` | 向后剪切一个词 | 向后删除一个词 | 无（想要剪切就用 `M-DEL` 的反向版本，或先选区再 `C-w`） |
| `C-<backspace>` | 向前剪切一个词 | 向前删除一个词 | `M-DEL` 仍是向前剪切一个词 |
| `C-S-<backspace>` | 剪切整行 | 删除整行 | `C-a C-k C-k` |
| `M-n` / `M-p` | 无全局绑定 | 下/上一个错误 | minibuffer 里仍是历史记录 |
| `C-@` | 设置标记（终端里） | `async-shell-command` | 图形界面用 `C-SPC` 设标记 |
| `C-c C-v`（Python） | `python-check` | `pyvenv-activate` | `M-x python-check` |

**终端版 Emacs（`emacs -nw`）**里，`C-!`、`C-<return>`、`C-S-<return>`、`C-S-<backspace>` 这类组合键终端不会传给 Emacs，**无法使用**；`C-@` 会占用 `C-SPC`。本配置按图形界面使用设计。

---

## 6. 补全系统怎么用

本配置有**两套**补全，分工不同：

| | ido + smex | Corfu |
|---|---|---|
| 位置 | 底部 minibuffer | 光标处的弹窗 |
| 负责 | 选文件、选缓冲区、`M-x` 命令 | 写代码时补全变量、函数、路径 |
| 样式 | 横向 `{a \| b \| c}` | 纵向列表 |

### 6.1 ido（`C-x C-f`、`C-x b`、`C-x k` 等）

直接输入字符，候选会实时过滤。

| 键 | 作用 |
|---|---|
| `RET` | 选择当前（第一个）候选 |
| `C-s` / `C-r` | 在候选中向右/向左切换 |
| `TAB` | 显示完整候选列表 |
| `DEL` | 删字符；在路径末尾按会回到上一级目录 |
| `C-j` | 按输入的原样**新建**文件/缓冲区（当输入是某候选的前缀时用） |
| `C-f` | 放弃 ido，改用原版 `find-file` |
| `C-b` | 在 `C-x C-f` 里改用缓冲区选择（反之亦然） |
| `C-d` | 在当前目录打开 dired |
| `M-m` | 新建目录 |
| `M-p` / `M-n` | 历史记录 |
| `C-SPC` | 把当前过滤结果固定下来，继续在里面细筛 |
| `C-t` | 切换正则匹配 |
| `~/` | 跳到家目录 |
| `//` | 跳到根目录 |
| `C-g` | 取消 |

### 6.2 smex（`M-x`）

- 输入命令名片段过滤，`C-s` / `C-r` 切换候选，`RET` 执行。
- 最近、最常用的命令排在最前。
- `C-h f` 在候选上查看该命令的文档。
- smex 多年未更新但仍可用；它的兼容分支 `amx` 有人维护，可以直接替换。

### 6.3 Corfu 弹窗（写代码时）

- 输入 **1 个字符、停顿 0.1 秒**后自动弹出。
- `↑` / `↓`：在候选中移动（到头会循环）。
- `TAB`：补全；`RET`：插入选中的候选（没选中时就是换行）。
- `C-g` 或 `ESC`：关闭弹窗。
- `C-M-i`（或 `M-TAB`）：手动触发补全。
- 因为 `C-n` 被改成了 `dabbrev-expand`，**不能**再用 `C-n` 在弹窗里下移，请用方向键。
- 候选来源：
  - C/C++/Python：`dabbrev`（缓冲区里已有的词，排前）+ LSP（clangd / pyright）
  - 其它缓冲区：文件路径（Cape file）+ 语言关键字（Cape keyword）
  - Python 缓冲区额外有文件路径补全（写 `open("./...")` 时有用）
- Orderless 让弹窗支持**空格分隔的多个片段**，顺序无关：输入 `get val` 能匹配 `get_value`、`value_get`。
- `corfu-history` 记住你的选择，常用项下次排得更前（保存在 `savehist`）。

### 6.4 `C-n` 的 dabbrev

写了一个很长的变量名，下次只打开头几个字符，按 `C-n` 就补全；继续按 `C-n` 循环下一个候选。原版里 `M-/` 就是这个功能，仍然可用。

---

## 7. Emacs 原版常用快捷键

下面是 Emacs 自带、本配置**没改**的键（除 5 节列出的以外）。

### 7.1 退出与取消

| 键 | 作用 |
|---|---|
| `C-g` | **取消**当前命令（卡住时先按它） |
| `ESC ESC ESC` | 退出各种状态（弹窗、多窗口提示等） |
| `C-x C-c` | 退出 Emacs |

### 7.2 文件与缓冲区

| 键 | 作用 |
|---|---|
| `C-x C-f` | 打开文件（ido） |
| `C-x C-s` | 保存 |
| `C-x C-w` | 另存为 |
| `C-x s` | 保存所有已修改的缓冲区 |
| `C-x C-v` | 用另一个文件替换当前缓冲区 |
| `C-x i` | 把另一个文件内容插入到光标处 |
| `C-x b` | 切换缓冲区（ido） |
| `C-x C-b` | 缓冲区列表 |
| `C-x k` | 关闭缓冲区 |
| `C-x <left>` / `C-x <right>` | 上一个/下一个缓冲区 |
| `C-x d` | 打开 dired（文件管理器） |
| `C-x C-j` | 在 dired 中定位到当前文件 |

### 7.3 窗口

| 键 | 作用 |
|---|---|
| `C-x 2` | 上下分屏 |
| `C-x 3` | 左右分屏 |
| `C-x 1` | 只保留当前窗口 |
| `C-x 0` | 关闭当前窗口 |
| `C-x o` | 切换到另一个窗口 |
| `C-x ^` | 窗口变高 |
| `C-x {` / `C-x }` | 窗口变窄/变宽 |
| `C-x +` | 各窗口大小平均 |
| `C-M-v` | 滚动另一个窗口 |

### 7.4 光标移动

| 键 | 作用 |
|---|---|
| `C-f` / `C-b` | 前进/后退一个字符 |
| `M-f` / `M-b` | 前进/后退一个词 |
| `C-p` | 上一行 |
| `C-e` | 行尾 |
| `M-m` | 行首第一个非空白字符 |
| `M-a` / `M-e` | 上/下一个句子 |
| `M-{` / `M-}` | 上/下一个段落 |
| `C-v` / `M-v` | 向下/向上翻页 |
| `M-<` / `M->` | 缓冲区开头/结尾 |
| `C-l` | 把光标所在行滚到屏幕中间（再按滚到顶部、底部） |
| `M-g g` | 跳到指定行号 |
| `M-g i` | 在当前文件里按函数/符号跳转（imenu） |
| `C-M-f` / `C-M-b` | 跳过一个括号表达式 |
| `C-M-a` / `C-M-e` | 跳到函数开头/结尾 |
| `C-x C-x` | 交换光标与标记的位置 |
| `C-u C-SPC` | 回到上一个标记位置（可连按） |

### 7.5 剪切、复制、粘贴（kill ring）

Emacs 把"剪切"叫 kill，"粘贴"叫 yank。被剪切的内容放进 **kill ring**，可以回溯。

| 键 | 作用 |
|---|---|
| `C-SPC` | 设置标记（开始选区），再移动光标即选中 |
| `C-w` | 剪切选区 |
| `M-w` | 复制选区 |
| `C-y` | 粘贴 |
| `M-y` | 粘贴后，换成更早的一条（紧接在 `C-y` 之后按） |
| `C-k` | 剪切到行尾 |
| `M-DEL` | 向前剪切一个词 |
| `M-z` | 剪切到某个字符（再按该字符） |
| `C-x h` | 全选 |
| `M-h` | 选中当前段落 |
| `C-M-SPC` | 选中一个括号表达式 |
| `M-@` | 选中一个词 |

### 7.6 其它编辑

| 键 | 作用 |
|---|---|
| `C-d` / `DEL` | 删除光标后/前一个字符 |
| `C-o` | 在光标处插入空行 |
| `C-j` | 换行并自动缩进 |
| `M-^` | 把当前行并到上一行 |
| `M-\` | 删掉光标周围所有空白 |
| `M-SPC` | 把光标周围空白压成一个空格 |
| `C-x C-o` | 把连续空行压成一行 |
| `C-t` / `M-t` / `C-x C-t` | 交换字符 / 词 / 行 |
| `M-u` / `M-l` / `M-c` | 词转大写 / 小写 / 首字母大写 |
| `M-;` | 注释/取消注释（选区时作用于选区） |
| `M-q` | 重排段落 |
| `C-M-\` | 重新缩进选区 |
| `TAB` | 缩进当前行 |
| `C-q` | 输入下一个按键的字面字符（比如真正的 Tab：`C-q TAB`） |
| `C-u 数字 命令` | 重复执行，如 `C-u 8 C-f` 前进 8 个字符 |
| `C-x z` | 重复上一条命令（再按 `z` 继续） |

### 7.7 搜索与替换

| 键 | 作用 |
|---|---|
| `C-s` | 向前增量搜索（再按 `C-s` 下一个） |
| `C-r` | 向后增量搜索 |
| `C-w`（搜索中） | 把光标处的词加入搜索串 |
| `M-c`（搜索中） | 切换大小写敏感 |
| `M-r`（搜索中） | 切换正则 |
| `RET`（搜索中） | 结束搜索，留在当前位置 |
| `C-g`（搜索中） | 取消搜索，回到起点 |
| `M-%`（搜索中） | 把当前搜索变成替换 |
| `C-M-s` | 正则搜索 |
| `M-%` | 询问式替换 |
| `C-M-%` | 正则替换 |
| `M-s o` | `occur`：把所有匹配行列在新窗口，点击/回车跳转 |
| `M-s .` | 搜索光标处的符号 |

询问式替换时：`y` 替换，`n` 跳过，`!` 全部替换，`q` 退出，`.` 替换这一处并结束。

### 7.8 跨文件搜索与跳转

| 键 | 作用 |
|---|---|
| `M-.` / `M-,` / `M-?` | 定义 / 跳回 / 引用（xref，LSP 提供） |
| `C-x p f` | 在当前项目里找文件 |
| `C-x p g` | 在项目里搜索正则 |
| `C-x p b` | 项目内的缓冲区 |
| `C-x p p` | 切换项目 |
| `C-x p c` | 在项目根目录编译 |
| `C-x p d` | 打开项目根目录的 dired |
| `C-x p k` | 关闭该项目的所有缓冲区 |
| `M-x rgrep` | 递归 grep |
| `M-g n` / `M-g p` | 跳到下一个/上一个编译错误或 grep 结果 |

`C-x p g` 默认用 `grep`。装了 `ripgrep` 想加速，在 `init.el` 里加：

```elisp
(setq xref-search-program 'ripgrep)
```

### 7.9 矩形、寄存器、书签

| 键 | 作用 |
|---|---|
| `C-x SPC` | 矩形选择模式（列选择） |
| `C-x r k` / `C-x r y` | 剪切/粘贴矩形 |
| `C-x r t` | 给矩形每行插入同一段文字 |
| `C-x r s a` | 把选区存入寄存器 `a` |
| `C-x r i a` | 插入寄存器 `a` 的内容 |
| `C-x r SPC a` | 把当前位置存入寄存器 `a` |
| `C-x r j a` | 跳到寄存器 `a` 保存的位置 |
| `C-x r m` | 设置书签 |
| `C-x r b` | 跳到书签 |
| `C-x r l` | 书签列表 |

### 7.10 键盘宏（录制重复操作）

| 键 | 作用 |
|---|---|
| `F3` | 开始录制 |
| `F4`（录制中） | 停止录制 |
| `F4`（非录制中） | 执行刚录制的宏 |
| `C-u 100 F4` | 连续执行 100 次 |
| `M-x apply-macro-to-region-lines` | 对选区每一行执行宏 |

### 7.11 Dired（文件管理器）

`C-x d` 打开，常用键：

| 键 | 作用 |
|---|---|
| `n` / `p` | 下/上一项 |
| `RET` | 打开 |
| `^` | 上一级目录 |
| `m` / `u` | 标记 / 取消标记 |
| `d` | 标记删除，再按 `x` 执行 |
| `C` / `R` | 复制 / 重命名或移动 |
| `+` | 新建目录 |
| `g` | 刷新 |
| `C-x C-q` | 进入可编辑模式，像改文本一样批量重命名（`C-c C-c` 提交） |

### 7.12 帮助系统（学 Emacs 最有用的一组）

| 键 | 作用 |
|---|---|
| `C-h t` | 交互式教程 |
| `C-h k` | 按下一个键，告诉你它做什么 |
| `C-h f` | 查看某个函数/命令的文档 |
| `C-h v` | 查看某个变量的文档 |
| `C-h m` | 查看当前模式的说明和快捷键 |
| `C-h b` | 列出当前所有快捷键 |
| `C-h w` | 查某个命令绑定在哪个键上 |
| `C-h a` | 按关键字搜索命令 |
| `C-h l` | 最近按过的键 |
| `C-h e` | 打开 `*Messages*` 缓冲区 |
| `C-h i` | Info 手册阅读器 |
| `C-h r` | Emacs 官方手册 |
| `C-x` 之后按 `C-h` | 列出 `C-x` 开头的所有键（任何前缀都可以这样用） |

### 7.13 求值 Emacs Lisp

| 键 | 作用 |
|---|---|
| `C-x C-e` | 执行光标前的表达式，结果显示在 minibuffer |
| `C-M-x` | 执行光标所在的整个函数定义 |
| `M-:` | 输入并执行一个表达式 |
| `C-j`（在 `*scratch*` 里） | 执行并把结果插入缓冲区 |
| `M-x eval-buffer` | 执行整个缓冲区 |

---

## 8. Emacs 特性速览

**缓冲区（buffer）、窗口（window）、框架（frame）**
Emacs 的术语和常见软件不同：一个"窗口"是 Emacs 内部的一块分屏区域，"框架"才是桌面上的整个 Emacs 窗口。缓冲区是内存里的文本，不一定对应文件。

**光标（point）与标记（mark）**
选区是"标记"到"光标"之间的区域。每次设置标记，旧位置都会存入 **mark ring**，`C-u C-SPC` 可以逐个跳回，相当于"返回上一个位置"。

**kill ring 与 undo**
剪切的内容会保存在 kill ring 里（本配置的删除类命令除外）。Emacs 的撤销是**树状**的：撤销之后再做别的修改，之前被撤销的内容也不会丢，连续撤销可以回溯。

**主模式与次模式**
每个缓冲区有一个主模式（如 C、Python），决定缩进、高亮、快捷键；可以叠加多个次模式（如 `flycheck-mode`、`lsp-mode`）。`C-h m` 能看到当前所有生效的模式。

**包管理**
`M-x list-packages` 打开包列表：`U` 标记可升级的包，`x` 执行；`i` 标记安装，`d` 标记删除。本配置的包都通过 `use-package` 自动安装。

**自定义（Customize）**
`M-x customize` 的设置会写入 `~/.emacs-bc/custom.el`，不会污染 `init.el`。

**minibuffer 历史**
在 minibuffer 里，`M-p` / `M-n` 翻历史命令。`savehist` 把这些历史保存到磁盘，重启后仍在。

**TRAMP（远程编辑）**
`C-x C-f` 后输入 `/ssh:用户@主机:/路径` 就能像编辑本地文件一样编辑远程文件，包括 `sudo`：`/sudo::/etc/hosts`。

**Daemon 模式（启动更快）**
```bash
emacs --daemon          # 后台启动
emacsclient -c          # 连接并新开窗口
```

**菜单栏**
本配置关闭了菜单栏，但 `F10` 仍可打开菜单；`M-x menu-bar-mode` 切换常驻显示。

**其它自带的东西**
`M-x shell` / `M-x eshell`（终端）、`M-x calendar`、`M-x org-mode`（笔记/待办/文学编程）、`M-x ediff`（文件比较）、`M-x proced`（进程管理）、`C-x C-+` / `C-x C--` / `C-x C-0`（缩放字体）。

---

## 9. 缓存文件位置

`code.el` 把 Emacs 自动生成的文件集中放到 **`~/.emacs-bc/`**：

| 文件 | 内容 |
|---|---|
| `文件名~` | 备份文件（用复制方式备份） |
| `#文件名#` | 自动保存文件 |
| `custom.el` | Customize 界面产生的设置 |
| `savehist` | minibuffer 历史、Corfu 使用历史 |

锁文件（`.#xxx`）已被禁用。

---

## 10. 已知问题与修复建议

以下是根据上传的配置文件检查出来的问题，建议修复：

### 10.1 `C-c r` 重载配置会出错

`keybinds.el` 中的 `my-reload-config` 从 `user-emacs-directory` 直接加载 `ui.el`、`code.el` 等文件，但这些文件实际在 `lisp/` 子目录里；它还试图加载不存在的 `early-init.el`。

**修复**：把整个函数换成：

```elisp
(defun my-reload-config ()
  "Reload init.el (which loads every file in lisp/)."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (mapc #'enable-theme custom-enabled-themes)
  (message "✅ Configuration reloaded!"))
```

### 10.2 `C-c l r` 绑定了一个不是命令的符号

`keybinds.el` 里：

```elisp
(global-set-key (kbd "C-c l r") 'lsp-restart)
```

在 lsp-mode 中，`lsp-restart` 是一个**变量**（控制服务器退出后的处理方式），不是命令，按键会报错。重启服务器的命令是 `lsp-restart-workspace`。

**修复**：

```elisp
(global-set-key (kbd "C-c l r") 'lsp-restart-workspace)
```

### 10.3 Makefile 里 Tab 可能被换成空格

`code.el` 全局设置了 `indent-tabs-mode nil`。之前的配置里有一个给 Makefile 恢复 Tab 的 hook，现在被删掉了。Makefile 的命令行必须以真正的 Tab 开头，否则 `make` 报 `missing separator`。

**修复**：在 `langs.el` 或 `code.el` 中加：

```elisp
(add-hook 'makefile-mode-hook (lambda () (setq indent-tabs-mode t)))
```

不加的话，遇到问题时用 `C-q TAB` 输入真正的 Tab。

### 10.4 一些可选的小改进

- **`C-n` 被占用后想保留下移**：把 `dabbrev-expand` 换到另一个键，例如在 `keybinds.el` 里把 `(global-set-key (kbd "C-n") 'dabbrev-expand)` 改成 `(global-set-key (kbd "C-;") 'dabbrev-expand)`，这样 `C-n` 恢复为下一行（原版 `M-/` 本来也可用）。
- **按了前缀键想看后面有哪些键**：Emacs 30 起内置 `which-key`，加 `(which-key-mode 1)` 即可。
- **错误提示重复**：`lsp-ui-sideline` 和 `flycheck-pos-tip` 会同时显示同一处错误。觉得吵就删掉 `flycheck-pos-tip` 那一段。
- **`lspmode.el` 里的 `lsp-zig-zls-executable`**：zig 的配置已经不在了，这行可以删掉，留着也无害。

---

## 速查：最常用的 20 个操作

| 想做什么 | 键 |
|---|---|
| 打开文件 | `C-x C-f` |
| 保存 | `C-x C-s` |
| 切换缓冲区 | `C-x b` |
| 搜索 | `C-s` |
| 执行命令 | `M-x` |
| 跳转定义 / 返回 | `M-.` / `M-,` |
| 下一个错误 | `M-n` |
| 编译 | `C-!` |
| 撤销 / 重做 | `C-z` / `C-/` |
| 复制 / 剪切 / 粘贴 | `M-w` / `C-w` / `C-y` |
| 注释 | `M-;` |
| 上下移动行 | `M-<up>` / `M-<down>` |
| 分屏 / 切换窗口 | `C-x 2` `C-x 3` / `C-x o` |
| 窗口之间跳转 | `C-c <方向键>` |
| 项目内找文件 | `C-x p f` |
| Git | `C-x g` |
| 激活 Python 虚拟环境 | `C-c C-v` |
| 取消 | `C-g` |
| 查看某个键做什么 | `C-h k` |
| 退出 | `C-x C-c` |
