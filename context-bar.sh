#!/bin/sh
# Context doluluğunu 8 karakterlik ASCII barla basar: "[####----] 62%"
# Fikir avenoxai/avenoxstatusline'dan. 60'ı geçince sarı, 75'i geçince kırmızı; altında widget rengi (#d0d0d0).
pct=$(jq -r '.context_window.used_percentage // empty' 2>/dev/null)
[ -z "$pct" ] && exit 0
p=${pct%.*}; p=${p:-0}
[ "$p" -lt 0 ] && p=0
[ "$p" -gt 100 ] && p=100
w=8; fill=$(( p * w / 100 ))
bar=""; i=0
while [ $i -lt $w ]; do
  if [ $i -lt $fill ]; then bar="${bar}#"; else bar="${bar}-"; fi
  i=$(( i + 1 ))
done
if [ "$p" -gt 75 ]; then c='\033[38;2;224;108;117m'
elif [ "$p" -gt 60 ]; then c='\033[38;2;229;192;123m'
else c='\033[38;2;208;208;208m'; fi
printf "${c}[%s] %s%%\033[0m" "$bar" "$p"
