#!/usr/bin/env bash
# 把筆記 HTML 轉成 PDF（macOS／Linux）。Windows 請用 note2pdf.ps1。
#
# 用法：bash tools/note2pdf.sh "115-1/課名/筆記/原始檔/W01-主題.html"
#
# - HTML 放在「原始檔」資料夾時，PDF 輸出到上一層（<課名>/筆記/）；否則輸出在 HTML 旁邊。
# - 轉檔前自動把 <details> 全部展開，否則自我檢核的答案在 PDF 裡是收合的。
# - 只需要 Chrome、Edge 或 Chromium 其中一個，不用另外裝套件。
#   找不到瀏覽器時，可用環境變數指定：BROWSER_BIN="/path/to/chrome" bash tools/note2pdf.sh ...
set -euo pipefail

SRC="${1:-}"
if [ -z "$SRC" ] || [ ! -f "$SRC" ]; then
  echo "用法：bash tools/note2pdf.sh <筆記.html>" >&2
  exit 1
fi

find_browser() {
  if [ -n "${BROWSER_BIN:-}" ]; then echo "$BROWSER_BIN"; return; fi
  local c
  for c in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"; do
    [ -x "$c" ] && { echo "$c"; return; }
  done
  for c in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge microsoft-edge-stable; do
    command -v "$c" >/dev/null 2>&1 && { command -v "$c"; return; }
  done
  return 1
}

BROWSER="$(find_browser)" || {
  echo "找不到 Chrome／Edge／Chromium。請先安裝 Google Chrome，或用 BROWSER_BIN 指定瀏覽器路徑。" >&2
  exit 1
}

SRC_DIR="$(cd "$(dirname "$SRC")" && pwd)"
SRC_ABS="$SRC_DIR/$(basename "$SRC")"
BASE="$(basename "${SRC_ABS%.*}")"
if [ "$(basename "$SRC_DIR")" = "原始檔" ]; then
  OUT_DIR="$(dirname "$SRC_DIR")"
else
  OUT_DIR="$SRC_DIR"
fi
OUT="$OUT_DIR/$BASE.pdf"

# 暫存檔放在原始檔旁邊，HTML 裡用相對路徑引用的圖片才找得到
TMP_HTML="$SRC_DIR/.$BASE.print.html"
trap 'rm -f "$TMP_HTML"' EXIT

N=$(grep -o '<details' "$SRC_ABS" | wc -l | tr -d ' ')
perl -pe 's/<details(?![^>]*\bopen\b)/<details open/g' "$SRC_ABS" > "$TMP_HTML"
echo "  展開 $N 個 details"

"$BROWSER" --headless --disable-gpu --no-pdf-header-footer \
  --virtual-time-budget=5000 \
  --print-to-pdf="$OUT" "file://$TMP_HTML" >/dev/null 2>&1

if [ ! -s "$OUT" ]; then
  echo "轉檔失敗：沒有產生 $OUT" >&2
  exit 1
fi

# 頁數＝頁面樹根節點的 /Count（取最大值）；抓不到就不顯示
PAGES=$(LC_ALL=C grep -aoE '/Count [0-9]+' "$OUT" | awk '{ if ($2 > m) m = $2 } END { print m + 0 }' || true)
echo "  → $OUT"
echo "    $PAGES 頁"
