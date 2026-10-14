#!/bin/sh
# Session bloğunu tek parça basar: kullanım, kalan süre ve yerel reset saati
read -r pct ts <<EOT
$(jq -r '.rate_limits.five_hour | "\(.used_percentage // "") \(.resets_at // "")"' 2>/dev/null)
EOT
[ -z "$pct" ] && [ -z "$ts" ] && exit 0
out="Session: $(LC_ALL=C /usr/bin/printf '%.1f' "$pct")%"
if [ -n "$ts" ]; then
  ts=${ts%.*}
  left=$(( ts - $(date +%s) )); [ $left -lt 0 ] && left=0
  h=$(( left / 3600 )); m=$(( left % 3600 / 60 ))
  if [ $h -gt 0 ]; then dur="${h}hr ${m}m"; else dur="${m}m"; fi
  out="$out · $dur · $(date -r "$ts" +%H:%M)"
fi
# Renk widget'ta değil burada: preserveColors açık, eşiğe göre varsayılan → sarı → kırmızı
YELLOW_AT=70
RED_AT=90
p=${pct%.*}; p=${p:-0}
if [ "$p" -ge "$RED_AT" ]; then color='\033[1;38;2;255;59;59m'
elif [ "$p" -ge "$YELLOW_AT" ]; then color='\033[1;38;2;255;215;0m'
else color=''
fi
printf "${color}✻ %s ✻\033[0m" "$out"
