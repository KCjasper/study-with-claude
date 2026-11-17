# Moodle adapter

> 狀態：**尚未在台灣學校實測**。Moodle 各校版本與外掛差很多，以下是大多數 Moodle 都有的網頁功能。試過後請回報你的學校與修正。

## 前提

- 學生自己在瀏覽器登入學校的 Moodle。
- Moodle 的網頁 API 需要 sesskey、各校設定不同，所以這份 adapter **以讀網頁為主**，不呼叫內部 API。

## 查未交作業（給 `/check-todos`）

1. **時間軸／即將到期**：登入後的「我的主頁」（`/my/`）通常有「時間軸」區塊，列出即將到期的活動。用 `get_page_text` 讀。
2. **行事曆**：`/calendar/view.php?view=upcoming` 列出近期事件。
3. **每份作業的繳交狀態**：作業頁面（`/mod/assign/view.php?id=<id>`）的「繳交狀態」表格，看「繳交狀態」與「截止時間」兩列。
4. **匯出行事曆**：`/calendar/export.php` 可以產生 .ics 訂閱網址（含所有截止日）。網址等同個人鑰匙，不要寫進會上傳的檔案。

## 下載教材

- 課程頁的檔案連結（`/mod/resource/view.php?id=<id>`）會轉到 `/pluginfile.php/...`，在分頁裡 navigate 過去即可下載。
- 一次下載很多檔案：有些學校開放「下載資料夾」（zip）；沒有就一個一個來。
- 下載完搬進課程 `講義/`。
