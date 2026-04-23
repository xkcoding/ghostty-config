# ghostty-config

带个性的 [Ghostty](https://ghostty.org) 终端配置，一行命令安装——明暗双主题、CJK 对齐字体、Quake 式快速终端，对 Agent 友好。

> 🇺🇸 [English README](./README.md)

---

## 🤖 AI Agent 安装说明

非交互、幂等，可在无人值守下运行。

```bash
curl -fsSL https://raw.githubusercontent.com/xkcoding/ghostty-config/main/install.sh | bash
```

契约：

- **依赖**：`git`、`bash`，macOS 或 Linux，`$HOME/.config/` 可写。
- **副作用**：
  - 将仓库克隆到 `$HOME/.config/ghostty-config`（可用 `GHOSTTY_CONFIG_DIR` 覆盖）。
  - 在 `$HOME/.config/ghostty/config` 和 `$HOME/.config/ghostty/themes/*` 建立软链，指向上述 checkout。
  - 如原路径存在真实文件，会重命名为 `<file>.backup.<epoch>`——**绝不删除**。
- **幂等**：重复执行会 `git pull --ff-only` 并刷新软链。
- **退出码**：`0` 成功；其它值表示失败（git 缺失、克隆失败、路径冲突等）。
- **无交互**、**无 sudo**，除 git clone/pull 外无其它网络调用。
- **卸载**：`bash $HOME/.config/ghostty-config/uninstall.sh`——仅移除本脚本创建的软链。

可选环境变量：

| 变量 | 默认值 | 作用 |
|---|---|---|
| `GHOSTTY_CONFIG_REPO` | `https://github.com/xkcoding/ghostty-config.git` | 源仓库地址 |
| `GHOSTTY_CONFIG_REF`  | `main` | 要检出的分支 / tag / commit |
| `GHOSTTY_CONFIG_DIR`  | `$HOME/.config/ghostty-config` | 本地 checkout 位置 |
| `GHOSTTY_TARGET_DIR`  | `$HOME/.config/ghostty` | Ghostty 配置目录 |

安装后，在 Ghostty 中按 `cmd+shift+,` 重载配置，或重启 Ghostty 生效。

---

## 🧑 人类使用者（或者直接扔给 Agent——都 2026 年了）

### 一行安装

```bash
curl -fsSL https://raw.githubusercontent.com/xkcoding/ghostty-config/main/install.sh | bash
```

### 或者先克隆再执行（想审阅脚本）

```bash
git clone https://github.com/xkcoding/ghostty-config.git ~/.config/ghostty-config
~/.config/ghostty-config/install.sh
```

### 后续更新

```bash
~/.config/ghostty-config/install.sh
```

再跑一次即可——脚本会 `git pull` 并重建软链。

### 卸载

```bash
~/.config/ghostty-config/uninstall.sh
```

**只移除本仓库创建的软链，不会动备份，也不会自动恢复**。脚本会列出找到的 `*.backup.*` 文件，方便你查看可用备份。

#### 恢复之前的配置

首次运行 `install.sh` 时，原有文件会被重命名为 `<name>.backup.<时间戳>`。回滚步骤：

```bash
# 1. 先卸载软链（如果还没卸载）
~/.config/ghostty-config/uninstall.sh

# 2. 查找备份
ls ~/.config/ghostty/*.backup.* ~/.config/ghostty/themes/*.backup.* 2>/dev/null

# 3. 挑一个时间戳，去掉 .backup.<timestamp> 后缀 mv 回去
mv ~/.config/ghostty/config.backup.1773628841 ~/.config/ghostty/config

# 4.（可选）删除本地 checkout
rm -rf ~/.config/ghostty-config
```

然后在 Ghostty 里按 `cmd+shift+,` 重载，或重启 Ghostty。

---

## 仓库结构

```
config                  # Ghostty 主配置
themes/xkcoding-ghostty # 自定义主题
install.sh              # 克隆 + 软链
uninstall.sh            # 移除软链
```

安装脚本采用**软链**而非复制，修改 `~/.config/ghostty-config/` 下的文件后重载 Ghostty 立即生效。改完 commit & push 即可分享给别人。

## 配置速览

[`config`](./config) 里每个选项都有行内注释。主要分组：

| 分组 | 控制内容 |
|---|---|
| Typography | 字号、中文字形映射到 PingFang SC、行高 |
| Theme and Appearance | 跟随 macOS 明暗自动切换（`Yozakura` / `Sakura`）、透明度、毛玻璃 |
| Window | 标题栏样式、内边距、窗口状态、Tab 风格 |
| Cursor / Mouse | 光标样式、输入时隐藏鼠标、选中即复制 |
| Quick Terminal | `ctrl+` `` ` `` 从顶部下拉的 Quake 式快速终端 |
| Behavior / Security | 关闭确认、剪贴板粘贴保护 |
| Shell Integration | Shell 自动识别、cursor/sudo 特性 |
| Keybindings | Tab、分屏、字号、快速终端、重载（macOS 风格） |
| Performance | 回滚缓冲上限 |

不清楚的选项可查阅 [Ghostty 官方配置参考](https://ghostty.org/docs/config/reference)。

## 特性亮点

- 明暗主题跟随 macOS 外观自动切换。
- 通过 PingFang SC 码点映射实现 CJK 对齐渲染。
- Quake 风格快速终端 + 完整 macOS 风格键位。
- 基于软链安装：改仓库 → 重载 → 立即生效。

## License

[MIT](./LICENSE)
