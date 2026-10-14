#!/bin/sh
# ccstatusline ayarını ve script'leri ~/.config/ccstatusline altına kurar.
# Mevcut dosyalar *.bak.<zaman> olarak yedeklenir.
set -eu

DEST="${CCSTATUSLINE_DIR:-$HOME/.config/ccstatusline}"
HERE=$(cd "$(dirname "$0")" && pwd)
STAMP=$(date +%Y%m%d-%H%M%S)

command -v jq >/dev/null 2>&1 || { echo "jq gerekli (brew install jq)" >&2; exit 1; }

mkdir -p "$DEST"
for f in settings.json model-effort.sh session-block.sh; do
  [ -f "$DEST/$f" ] && cp "$DEST/$f" "$DEST/$f.bak.$STAMP"
done

cp "$HERE/model-effort.sh" "$HERE/session-block.sh" "$DEST/"
chmod +x "$DEST/model-effort.sh" "$DEST/session-block.sh"
# {{HOME}} yer tutucusu: ccstatusline commandPath için mutlak yol ister.
sed "s|{{HOME}}|$HOME|g" "$HERE/settings.json" > "$DEST/settings.json"

echo "Kuruldu: $DEST"
echo
echo "Claude Code'a bağlamak için ~/.claude/settings.json içine ekle:"
echo '  "statusLine": { "type": "command", "command": "ccstatusline", "padding": 0, "refreshInterval": 60 }'
