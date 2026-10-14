# ccstatusline-config

My [ccstatusline](https://github.com/sirmalloc/ccstatusline) setup for Claude Code: one compact line with project, branch, model and effort, context size, 5-hour session usage and weekly usage.

```text
my-project  main  (+0,-0)  Sonnet 5.5 (Medium)  Ctx: 120.0k  ✻ Session: 42.0% · 3hr 10m · 18:50 ✻  Weekly: 31.0%
```

## What is in it

| Widget | Source |
| --- | --- |
| Repo, branch, changes | built-in `git-root-dir`, `git-branch`, `git-changes` (hidden outside git repos) |
| Model and effort | `model-effort.sh`: prints `Sonnet 5.5 (Medium)` as one block |
| Context | built-in `context-length` |
| Session | `session-block.sh`: usage, time left and local reset time of the 5-hour window |
| Weekly | built-in `weekly-usage` |

**Colors:** every widget is one neutral gray (`#d0d0d0` in `settings.json`; ccstatusline would otherwise give each widget its own color) so the line stays calm. The session block is the only one that reacts: default below 70%, bold yellow from 70%, bold red from 90% (`YELLOW_AT` / `RED_AT` in `session-block.sh`).

## Install

Needs Node (for `ccstatusline`) and `jq`.

```sh
npm i -g ccstatusline
git clone https://github.com/cemtatli/ccstatusline-config
cd ccstatusline-config
./install.sh
```

The installer copies the files to `~/.config/ccstatusline` (override with `CCSTATUSLINE_DIR`), backs up what was there, and replaces the `{{HOME}}` placeholder in `settings.json` with your home directory, because ccstatusline wants absolute script paths.

Then point Claude Code at it in `~/.claude/settings.json`:

```json
"statusLine": { "type": "command", "command": "ccstatusline", "padding": 0, "refreshInterval": 60 }
```

## Notes

- The scripts read the JSON that Claude Code pipes to the status line (`model`, `effort`, `rate_limits.five_hour`), so they need a Claude Code version that sends those fields. When a field is missing they print nothing.
- `model-effort.sh` falls back to `effortLevel` from `~/.claude/settings.json` when the status JSON has no effort.
- Tested with ccstatusline 2.2.22 on macOS (`date -r` in `session-block.sh` is the BSD form).

## License

MIT
