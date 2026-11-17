# 把筆記 HTML 轉成 PDF（Windows）。macOS／Linux 請用 note2pdf.sh。
#
# 用法（在工作區根目錄的 PowerShell）：
#   powershell -ExecutionPolicy Bypass -File tools\note2pdf.ps1 "115-1\課名\筆記\原始檔\W01-主題.html"
#
# - HTML 放在「原始檔」資料夾時，PDF 輸出到上一層（<課名>\筆記\）；否則輸出在 HTML 旁邊。
# - 轉檔前自動把 <details> 全部展開。
# - Windows 內建的 Microsoft Edge 就能轉，不用另外裝東西。
#   要指定瀏覽器：$env:BROWSER_BIN = "C:\path\to\chrome.exe"
param([Parameter(Mandatory = $true)][string]$Src)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Src -PathType Leaf)) {
    Write-Error "找不到檔案：$Src"
}

function Find-Browser {
    if ($env:BROWSER_BIN -and (Test-Path -LiteralPath $env:BROWSER_BIN)) { return $env:BROWSER_BIN }
    $candidates = @(
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
    )
    foreach ($c in $candidates) {
        if ($c -and (Test-Path -LiteralPath $c)) { return $c }
    }
    return $null
}

$browser = Find-Browser
if (-not $browser) {
    Write-Error "找不到 Chrome 或 Edge。請安裝 Google Chrome，或設定 `$env:BROWSER_BIN 指向瀏覽器執行檔。"
}

$srcFull = (Resolve-Path -LiteralPath $Src).Path
$srcDir = Split-Path -Parent $srcFull
$base = [System.IO.Path]::GetFileNameWithoutExtension($srcFull)
if ((Split-Path -Leaf $srcDir) -eq '原始檔') {
    $outDir = Split-Path -Parent $srcDir
} else {
    $outDir = $srcDir
}
$out = Join-Path $outDir "$base.pdf"

# 暫存檔放在原始檔旁邊，相對路徑的圖片才找得到
$tmp = Join-Path $srcDir ".$base.print.html"
$utf8 = New-Object System.Text.UTF8Encoding($false)
$html = [System.IO.File]::ReadAllText($srcFull, $utf8)
$n = ([regex]::Matches($html, '<details')).Count
$html = [regex]::Replace($html, '<details(?![^>]*\bopen\b)', '<details open')
[System.IO.File]::WriteAllText($tmp, $html, $utf8)
Write-Host "  展開 $n 個 details"

try {
    if (Test-Path -LiteralPath $out) { Remove-Item -LiteralPath $out }
    $uri = ([System.Uri]$tmp).AbsoluteUri
    $argList = @('--headless', '--disable-gpu', '--no-pdf-header-footer',
              '--virtual-time-budget=5000', "--print-to-pdf=`"$out`"", "`"$uri`"")
    Start-Process -FilePath $browser -ArgumentList $argList -Wait -WindowStyle Hidden
} finally {
    Remove-Item -LiteralPath $tmp -ErrorAction SilentlyContinue
}

if (-not (Test-Path -LiteralPath $out) -or (Get-Item -LiteralPath $out).Length -eq 0) {
    Write-Error "轉檔失敗：沒有產生 $out"
}

$bytes = [System.IO.File]::ReadAllBytes($out)
$text = [System.Text.Encoding]::GetEncoding(28591).GetString($bytes)
$pages = 0
foreach ($m in [regex]::Matches($text, '/Count (\d+)')) { $v = [int]$m.Groups[1].Value; if ($v -gt $pages) { $pages = $v } }
Write-Host "  → $out"
Write-Host "    $pages 頁"
