# TronClass adapter

> 狀態：**實測過**（淡江大學 iClass，2026 秋）。其他用 TronClass 的學校網址不同，API 路徑應該相同，歡迎回報。

## 前提

- 用 Claude in Chrome（或 Claude 桌面版內建瀏覽器）開學校的 TronClass 首頁，**學生自己登入**（學校 SSO 帳密絕不代填）。
- 以下 API 都在已登入的 TronClass 分頁裡用 `fetch('/api/...')` 呼叫（同源、帶著學生的登入狀態）。只讀學生本人的資料。
- 時間欄位是 UTC，台灣時間要 **+8 小時**。
- 回傳很長時，Chrome 擴充功能可能截斷：先存到 `window.__x`，再分段 `slice` 讀。

## 常用 API

| 用途 | 路徑 | 重點欄位 |
|---|---|---|
| 我是誰 | `/api/profile` | `id`（user id，查繳交紀錄用） |
| 我的課程 | `/api/my-courses` | 課程 id、名稱 |
| 課程資訊 | `/api/courses/<課程id>` | `subject_code`；`course_outline` 常是空的 |
| 課程所有活動 | `/api/courses/<課程id>/activities` | `type`（homework、material…）、`start_time`、`end_time`、`uploads[]` |
| 公告 | `/api/courses/<課程id>/bulletins` | 考試日期、作業規定常在這裡 |
| 跨課待辦 | `/api/todos` | `todo_list[]`：course_name、title、type、end_time |
| 活動詳情 | `/api/activities/<活動id>` | `submit_by_group`、`allow_download`、`topic_category_id` |
| 個人繳交紀錄 | `/api/activities/<活動id>/students/<user id>/submission_list` | `list` 空＝沒交 |
| 分組繳交紀錄 | `/api/activities/<活動id>/groups/<group id>/submission_list` | 分組作業看這個 |
| 下載教材 | `/api/uploads/<upload id>/blob` | 在分頁裡直接 navigate 過去會用原檔名下載 |

## 查未交作業（給 `/check-todos`）

1. 打 `/api/todos`。注意：
   - 它**不一定列出所有**未交作業。
   - 帶 `not_scored_num` 的項目是「已交、但還沒做完互評」，`end_time` 是互評截止，不是繳交截止。
2. 對每門課打 `/api/courses/<id>/activities`，挑 `type` 是 homework、`end_time` 還沒過的，逐一查 submission_list。
3. `submit_by_group: true` 的是分組作業：個人 list 會是空的，要查分組的 submission_list（group id 在活動詳情裡）。
4. 查別人的 submission_list 會回 403，這是正常的，不要嘗試。

## 下載教材

- 單一檔案：活動頁面的下載圖示，或 navigate 到 `/api/uploads/<id>/blob`。
- 批次：**一個一個 navigate**。用 JS 連續點 `<a download>` 只有第一個會成功，後面被瀏覽器的「多重下載」擋掉。
- `allow_download: false`（老師沒開放下載）的檔案，先問學生，並只供個人學習；可以改在頁面上用 pdf.js 讀文字，不下載。
- 下載完搬進課程 `講義/`。

## 課程影片

- 影片的 `<source>` 會 302 轉到物件儲存的預簽章網址（約 2 小時失效），跨網域直接 fetch 會失敗。
- 可行做法：對影片 source 建 `<a download>` 點下去 → 瀏覽器會開啟影片網址 → 在那個分頁（已同源）再建一次 `<a href=location.href download="檔名.mp4">` 點擊。
- 提醒學生：離線觀看**不算**平台上的觀看進度（如「累積觀看 80%」）；老師沒開放下載的影片先問。

## 討論區發文

需要學生每次明確同意內容才送出。

```js
fetch('/api/topics', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ title, content /* HTML，如 <p>…</p> */, category_id /* = 活動的 topic_category_id */, uploads: [] })
})  // 成功回 201
```

要附檔案時改用網頁介面（「新增檔案」→「本機上傳」）。`/api/activities/<id>/topics` 會回傳其他同學的貼文：只看格式，不引用內容。

## 互評進度

- 分組互評：`/api/activities/<id>/inter-score-rules`（`inter_scores[]` 有 `score` 就是評過）
- 組內互評：`/api/activities/<id>/intra-score-rules`
- 截止時間看活動的 `inter_score_map`、`intra_score_map`，老師可能延長。

## 已知學校

- 淡江大學 iClass：`https://iclass.tku.edu.tw/`；課程大綱 PDF 在學校教務系統，不在 TronClass 內。實習課在 TronClass 是另一門課。
