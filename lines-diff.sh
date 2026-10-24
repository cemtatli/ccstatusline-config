#!/bin/sh
# Session'daki satır farkını basar: "+120 -34" (soluk yeşil / soluk kırmızı)
read -r add del <<EOT
$(jq -r '"\(.cost.total_lines_added // 0) \(.cost.total_lines_removed // 0)"' 2>/dev/null)
EOT
add=${add:-0}; del=${del:-0}
# Hiç değişiklik yoksa widget kendini gizler
[ "$add" -eq 0 ] && [ "$del" -eq 0 ] && exit 0
printf '\033[38;2;125;170;125m+%s\033[0m \033[38;2;190;115;115m-%s\033[0m' "$add" "$del"
