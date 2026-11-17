# Canvas adapter

> 狀態：**尚未在台灣學校實測**。以下是 Canvas 公開文件中的標準 REST API；用 Canvas 的學校（例：臺大 NTU COOL）試過後請回報修正。

## 前提

- 學生自己在瀏覽器登入學校的 Canvas。
- 在已登入的 Canvas 分頁裡用 `fetch('/api/v1/...')` 讀取（同源 GET 會帶登入狀態）。**不要**請學生產生 access token 給 Claude。
- Canvas 回應有分頁：加 `?per_page=100`，必要時看回應標頭 `Link` 的 next。
- 時間是 ISO 8601（UTC，結尾 `Z`），台灣時間 +8 小時。

## 常用 API

| 用途 | 路徑 |
|---|---|
| 我是誰 | `/api/v1/users/self` |
| 我的課程 | `/api/v1/courses?enrollment_state=active&per_page=100` |
| 跨課待辦 | `/api/v1/users/self/todo` |
| 近期事件與作業 | `/api/v1/users/self/upcoming_events` |
| 某課所有作業（含我的繳交狀態） | `/api/v1/courses/<id>/assignments?include[]=submission&per_page=100` |
| 公告 | `/api/v1/announcements?context_codes[]=course_<id>` |
| 課程檔案 | `/api/v1/courses/<id>/files?per_page=100` |
| 課程大綱 | `/api/v1/courses/<id>?include[]=syllabus_body` |

## 查未交作業（給 `/check-todos`）

1. `/api/v1/users/self/todo` 拿待辦。
2. 逐課打 assignments（含 `include[]=submission`），挑 `due_at` 還沒過、`submission.workflow_state` 是 `unsubmitted` 的。
3. 分組作業看 assignment 的 `group_category_id`；繳交狀態以 submission 為準。

## 另一種方式：行事曆訂閱

Canvas 的「行事曆」頁有「行事曆摘要」（.ics 網址），裡面有所有作業截止日。學生可以自己把網址貼給 Claude，或匯入手機行事曆。這個網址等同個人鑰匙，不要寫進會上傳的檔案。
