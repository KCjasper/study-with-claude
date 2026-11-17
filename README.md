# study-with-claude：給台灣大學生的 Claude Code 學習工作區

把 [Claude Code](https://claude.com/claude-code) 變成你的課業家教：整理每門課的資訊、追蹤截止日、把講義整理成手機好讀的 PDF 筆記、陪你寫作業、幫你排考前複習。

**作業有兩種模式，你說了算**：想自己學會就說「陪我寫」，Claude 拆步驟、給提示、檢查你寫的東西；想直接看答案就說「幫我做完」，Claude 完整做完並附講解，讓你看得懂、被問到答得出來。

## 它能做什麼

| 你說 | Claude 會 |
|---|---|
| 「這是我的課表」（附截圖） | 建好每門課的資料夾和 README，記下老師、時間、評分方式、AI 規定 |
| 「有沒有沒交的作業？」 | 從學校教學平台查待辦，更新截止日表，依截止時間排出順序 |
| 「陪我寫 HW3」 | 先問你怎麼想，卡住才一階一階給提示，最後實際執行你的程式來檢查 |
| 「幫我把 HW3 做完」 | 完整做完，照課程檔名規則存好，附思路、逐步講解和常見錯誤 |
| 「把這週講義整理成筆記」 | 產生有逐行解說、常見錯誤、練習題的 PDF，存進課程資料夾 |
| 「下週期中考，幫我排複習」 | 讀你寫作業時卡住的紀錄找出弱點，排每日計畫、出模擬題考你 |

看完整示範：[examples/115-1/](examples/115-1/)（虛構課程「程式設計一」，含筆記 PDF、引導紀錄、截止日表）。

## 開始使用

需要：[Claude Code](https://claude.com/claude-code)（桌面版或終端機都可以）、Google Chrome 或 Microsoft Edge（轉 PDF 用）。macOS、Windows、Linux 都可以用。

1. 在 GitHub 上按 **Use this template** → 建立你自己的 repo，**設成 Private**（裡面會有你的作業）。
   不用 GitHub 的話，直接下載 zip 解壓也可以。
2. 用 Claude Code 打開這個資料夾。
3. 輸入 `/setup`，回答幾個問題（學校、科系、程式基礎、作業系統、學校教學平台）。
4. 輸入 `/new-semester`，貼上你的課表截圖。

## 資料夾長這樣

```
115-1/                         一學期一個資料夾（民國學年-學期）
├── README.md                  課表、課程表、截止日表、考試表
└── 程式設計一/
    ├── README.md              老師、評分、AI 規定、繳交規則、進度
    ├── 講義/                  老師的投影片（不會上傳 GitHub）
    ├── 作業/hw02-溫度換算/    題目、你的程式、引導紀錄
    └── 筆記/
        ├── W03-方法.pdf       ← 手機上看這個
        └── 原始檔/W03-方法.html
```

## 指令

| 指令 | 用途 |
|---|---|
| `/setup` | 第一次設定 |
| `/new-semester` | 建立新學期、加課 |
| `/check-todos` | 查未交作業與截止日 |
| `/homework` | 寫作業（引導或解答模式） |
| `/make-note` | 講義 → 筆記 PDF |
| `/exam-prep` | 考前複習計畫與模擬題 |

不用記指令，直接用中文說你要做什麼，Claude 也會選對的流程。

## 學校教學平台

| 平台 | 狀態 |
|---|---|
| TronClass（例：淡江 iClass） | 實測過 |
| Canvas（例：臺大 NTU COOL） | 待實測 |
| Moodle | 待實測 |
| 其他 | 截圖或貼上即可 |

Claude 透過你**已經登入**的瀏覽器分頁讀取資料，不會碰你的帳號密碼，也不會替你繳交作業或發文。詳見 [adapters/](adapters/)。

## 原則

1. **你決定怎麼用**：引導或解答，依你每次的說法切換；說得不清楚時 Claude 會先問。
2. **知道每門課的 AI 規定**：老師禁止 AI 代寫的課，Claude 會在給解答前提醒你一次規定，決定權在你。
3. **你按送出**：繳交、發文、寄信，都由你看過、你決定。
4. **隱私**：姓名、學號只存在本機的 `CLAUDE.local.md`，老師的講義與影片預設不上傳。

## 轉 PDF

```bash
bash tools/note2pdf.sh "115-1/程式設計一/筆記/原始檔/W03-方法.html"
```

Windows（PowerShell）：

```powershell
powershell -ExecutionPolicy Bypass -File tools\note2pdf.ps1 "115-1\程式設計一\筆記\原始檔\W03-方法.html"
```

平常不用自己打，Claude 會幫你跑。

## 一起改進

歡迎補上你們學校的教學平台 adapter、改進筆記範本、回報問題。見 [CONTRIBUTING.md](CONTRIBUTING.md)。

## 授權

[MIT](LICENSE)
