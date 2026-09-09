# Void Update Toolbox

A small, sci-fi-styled GUI for XBPS package updates on Void Linux —
the same idea as Garuda's update toolbox, but deliberately scoped to
**package management only**. It runs exactly two kinds of commands:

- `xbps-install` — sync repo data / check for updates / upgrade
- `xbps-remove` — drop orphans / clean the download cache

It never touches your bootloader, mirrors, kernel, configs,
snapshots, or anything outside XBPS's own package database.

![status](https://img.shields.io/badge/platform-Void%20Linux-2ee6ff)
![deps](https://img.shields.io/badge/deps-python3--tkinter-ff3fd6)

## Quick start

```bash
git clone https://github.com/queenoffiends/void-update-toolbox.git
cd void-update-toolbox
./void-update-toolbox
```

That's it — it's a single self-contained Python/Tkinter script, so if
your dependencies are already in place, running it directly is all
you need. No build step, no packaging.

## Proper install (adds it to your app menu + PATH)

```bash
./install.sh
```

This installs to your **user** directories (no root needed for the
app itself):

- `~/.local/bin/void-update-toolbox`
- `~/.local/share/applications/voidupdatetoolbox.desktop`
- `~/.local/share/icons/hicolor/scalable/apps/voidupdatetoolbox.svg`

It'll also offer to install missing dependencies via `xbps-install`
(that one step does need `sudo`). After installing, launch it from
your app menu or just type `void-update-toolbox` in a terminal.

To remove everything it installed:

```bash
./uninstall.sh
```

## Dependencies

```
sudo xbps-install -S python3 python3-tkinter polkit
```

- `python3` + `python3-tkinter` — the app itself (pure stdlib, no pip packages)
- `polkit` — gives you the graphical `pkexec` password prompt for the
  privileged actions; falls back to `sudo` if not present

## What the buttons do

| Button | Command run (as root) | Effect |
|---|---|---|
| Sync & Check | `xbps-install -Sun` | Refreshes repo index, dry-run lists what would change |
| Update System | `xbps-install -Suy` | Syncs + installs all available upgrades |
| Remove Orphans | `xbps-remove -oy` | Removes packages nothing else depends on |
| Clean Cache | `xbps-remove -O` | Deletes obsolete cached binpkgs |

All privileged commands go through `pkexec` (or `sudo` as a
fallback), and the two destructive actions ask for confirmation
first. Output streams live into the log panel, color-coded by type.

## Project layout

```
void-update-toolbox/
├── void-update-toolbox        # the app itself (Python/Tkinter, single file)
├── install.sh                 # per-user install (bin + desktop entry + icon)
├── uninstall.sh
├── voidupdatetoolbox.desktop  # blank till install.sh
├── icons/voidupdatetoolbox.svg
└── LICENSE
```

## Customizing scope further

Want it even more locked down (e.g. drop "Remove Orphans" or "Clean
Cache")? Each action is a self-contained ~10-line method in
`void-update-toolbox` (`action_check`, `action_update`,
`action_orphans`, `action_clean_cache`) — delete the method and its
matching button and you're done.

## Contributing

PRs welcome — this is intentionally a small, single-purpose tool, so
scope-creepy features (mirror management, snapshots, AUR-style
helpers, etc.) are likely to be declined in favor of keeping it doing
one thing well.
