---
name: setup
description: 第一次使用這個學習工作區時的設定：問學生的學校、科系、程式基礎、作業系統、學校教學平台和偏好，寫成 CLAUDE.local.md，並檢查轉 PDF 的環境。學生說「開始設定」「第一次用」或輸入 /setup 時使用。
---

# 第一次設定

## 1. 問學生（一次問完，可用選項卡）

1. 學校、科系、年級
2. 程式基礎：完全沒寫過／高中學過／大一學過但忘了／還算熟
3. 作業系統：macOS／Windows／Linux
4. 學校教學平台：TronClass／Canvas／Moodle／其他（請給網址）／不知道
5. 筆記深度：零基礎（預設）／一般／精簡重點
6. 姓名、學號：**選填**，只用來產生作業檔名；說明只會存在本機的 `CLAUDE.local.md`

## 2. 寫設定檔

把 [_templates/CLAUDE.local.範本.md](../../../_templates/CLAUDE.local.範本.md) 複製成工作區根目錄的 `CLAUDE.local.md`，填入答案。沒回答的欄位留空。

確認 `.gitignore` 裡有 `CLAUDE.local.md`。

## 3. 檢查轉檔環境

- macOS／Linux：執行 `bash tools/note2pdf.sh _templates/筆記範本.html`
- Windows：執行 `powershell -ExecutionPolicy Bypass -File tools\note2pdf.ps1 _templates\筆記範本.html`

成功會在 `_templates/` 產生 `筆記範本.pdf`，印出頁數。確認後刪掉這個測試 PDF。
失敗時：找不到瀏覽器就請學生裝 Google Chrome（Windows 通常有內建 Edge，不用裝）。

## 4. 學校平台

依學生選的平台讀對應的 `adapters/*.md`。沒有對應 adapter 就用 `adapters/manual.md`，並邀請學生之後照 `adapters/_範本.md` 補一份、回饋給專案。

## 5. 下一步

告訴學生接下來可以：
- `/new-semester`：給 Claude 課表截圖，建立這學期的資料夾
- `/check-todos`：查未交作業
- 看 `examples/115-1/` 了解整個工作區用起來的樣子
