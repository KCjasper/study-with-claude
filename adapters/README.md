# 學校教學平台 adapters

每份 adapter 告訴 Claude 怎麼在某個教學平台（LMS）上：查我的課程、查未交作業、讀公告、下載教材。

| 平台 | 檔案 | 狀態 |
|---|---|---|
| TronClass | [tronclass.md](tronclass.md) | 實測過（淡江 iClass） |
| Canvas | [canvas.md](canvas.md) | 待實測 |
| Moodle | [moodle.md](moodle.md) | 待實測 |
| 其他／連不上 | [manual.md](manual.md) | 截圖或貼上 |

不確定你們學校用哪個？登入後看網址或頁尾的系統名稱。

## 所有 adapter 共同的規則

1. **學生自己登入**。Claude 不輸入、不保存任何帳號密碼或 token。
2. **只讀學生本人的資料**。其他同學的貼文、作業只看格式，不引用、不保存內容。
3. **送出前問**：繳交作業、發文、回覆、寄信，每次都要學生看過並明確同意。
4. 老師沒開放下載的檔案，先問學生，只供個人學習。
5. 個人鑰匙類的網址（行事曆訂閱網址、含 token 的連結）不寫進會上傳 GitHub 的檔案。

## 貢獻

用 [_範本.md](_範本.md) 寫一份你們學校的平台，或在既有 adapter 補上「已知學校」與修正，開 Pull Request。請刪掉範例中的個人資料（學號、課程 id、姓名）。
