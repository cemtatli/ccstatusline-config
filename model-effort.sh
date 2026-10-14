#!/bin/sh
# Model ve thinking'i tek blokta basar: "Opus 5.5 (High)"
read -r model effort <<EOT
$(jq -r '"\(.model.display_name // "" | gsub(" "; " ")) \(.effort.level // "")"' 2>/dev/null)
EOT
# Status JSON'da effort yoksa Claude Code ayarına düş
[ -z "$effort" ] && effort=$(jq -r '.effortLevel // empty' ~/.claude/settings.json 2>/dev/null)
model=$(printf '%s' "$model" | sed 's/\xc2\xa0/ /g')
[ -z "$model" ] && [ -z "$effort" ] && exit 0
case "$effort" in
  xhigh) effort="XHigh" ;;
  "") ;;
  *) effort=$(printf '%s' "$effort" | awk '{print toupper(substr($0,1,1)) substr($0,2)}') ;;
esac
out="$model"
[ -n "$effort" ] && out="${out:+$out }($effort)"
printf '%s' "$out"
