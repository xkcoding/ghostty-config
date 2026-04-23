# ghostty-config

Opinionated [Ghostty](https://ghostty.org) terminal config with a one-line installer — dual light/dark themes, CJK-aligned fonts, Quake-style quick terminal, agent-friendly.

> 🇨🇳 [中文版 README](./README.zh-CN.md)

---

## 🤖 For AI Agents

Non-interactive, idempotent install. Safe to run unattended.

```bash
curl -fsSL https://raw.githubusercontent.com/xkcoding/ghostty-config/main/install.sh | bash
```

Contract:
- **Requires**: `git`, `bash`, macOS or Linux with `$HOME/.config/` writable.
- **Side effects**:
  - Clones repo to `$HOME/.config/ghostty-config` (override with `GHOSTTY_CONFIG_DIR`).
  - Creates symlinks `$HOME/.config/ghostty/config` and `$HOME/.config/ghostty/themes/*` pointing into that checkout.
  - Any pre-existing real files at those paths are renamed to `<file>.backup.<epoch>` — **never deleted**.
- **Idempotent**: re-running updates the checkout (`git pull --ff-only`) and refreshes symlinks.
- **Exit codes**: `0` success, non-zero on any failure (git missing, clone failure, path conflict).
- **No prompts**, no `sudo`, no network calls besides the git clone/pull.
- **Uninstall**: `bash $HOME/.config/ghostty-config/uninstall.sh` — removes only the symlinks it created.

Env overrides (all optional):

| Variable | Default | Purpose |
|---|---|---|
| `GHOSTTY_CONFIG_REPO` | `https://github.com/xkcoding/ghostty-config.git` | Source repo |
| `GHOSTTY_CONFIG_REF`  | `main` | Branch / tag / commit to check out |
| `GHOSTTY_CONFIG_DIR`  | `$HOME/.config/ghostty-config` | Local checkout location |
| `GHOSTTY_TARGET_DIR`  | `$HOME/.config/ghostty` | Ghostty config directory |

After install, Ghostty needs to reload the config (`cmd+shift+,`) or restart.

---

## 🧑 For Humans (or just let your agent do it — it's 2026)

### One-line install

```bash
curl -fsSL https://raw.githubusercontent.com/xkcoding/ghostty-config/main/install.sh | bash
```

### Or clone first (if you want to read the script before running)

```bash
git clone https://github.com/xkcoding/ghostty-config.git ~/.config/ghostty-config
~/.config/ghostty-config/install.sh
```

### Update later

```bash
~/.config/ghostty-config/install.sh
```

(Just re-run it — it does `git pull` + re-link.)

### Uninstall

```bash
~/.config/ghostty-config/uninstall.sh
```

This only removes the symlinks this repo created — **it does not touch backups or restore anything automatically**. The script will list any `*.backup.*` files it finds so you know what's available.

#### Restoring a previous config

When `install.sh` first ran, it saved your existing files as `<name>.backup.<timestamp>`. To roll back:

```bash
# 1. Uninstall the symlinks (if you haven't already)
~/.config/ghostty-config/uninstall.sh

# 2. Find your backup(s)
ls ~/.config/ghostty/*.backup.* ~/.config/ghostty/themes/*.backup.* 2>/dev/null

# 3. Restore the one you want (pick the timestamp)
mv ~/.config/ghostty/config.backup.1773628841 ~/.config/ghostty/config

# 4. (Optional) Delete the local checkout
rm -rf ~/.config/ghostty-config
```

Then reload Ghostty (`cmd+shift+,`) or restart it.

---

## What's inside

```
config                  # Ghostty main config
themes/xkcoding-ghostty # Custom theme
install.sh              # Clone + symlink
uninstall.sh            # Remove symlinks
```

The install script **symlinks** rather than copies, so editing the files under `~/.config/ghostty-config/` immediately affects the running Ghostty config after a reload. Commit & push those edits to share them.

## Configuration reference

Every option in [`config`](./config) has an inline comment. High-level groups:

| Section | What it controls |
|---|---|
| Typography | Font size, CJK glyph mapping to PingFang SC, cell height |
| Theme and Appearance | Light/dark auto-switch (`Yozakura` / `Sakura`), opacity, blur |
| Window | Title bar style, padding, save state, tab style |
| Cursor / Mouse | Cursor shape, auto-hide on type, copy-on-select |
| Quick Terminal | Quake-style dropdown from top on `ctrl+` `` ` `` |
| Behavior / Security | Close confirmations, clipboard paste protection |
| Shell Integration | Auto shell detection, cursor/sudo features |
| Keybindings | Tabs, splits, font size, quick terminal, reload (macOS-flavored) |
| Performance | Scrollback limit |

For anything non-obvious, see the [Ghostty config reference](https://ghostty.org/docs/config/reference).

## Highlights

- Dual theme with macOS appearance auto-switch.
- CJK aligned rendering via PingFang SC codepoint mapping.
- Quake-style quick terminal + full macOS-flavored keybindings.
- Symlink-based install: edit repo → reload → changes live.

## License

[MIT](./LICENSE)
