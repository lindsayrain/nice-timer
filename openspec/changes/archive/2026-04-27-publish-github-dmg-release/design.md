## Context

目前 NiceTimer 可以透過 shell script 建出 `.app` 與 `.zip`，但沒有 `.dmg` 安裝映像，也沒有自動把產物與 release notes 發佈到 GitHub Release。現有 `release-notes` 內容是英文，截圖連結也指向 feature branch，不適合作為正式版本頁面。

## Goals / Non-Goals

**Goals:**

- 讓維護者在建立版本 tag 後，自動得到可下載的 `.dmg` 與 `.zip`。
- 讓 GitHub Release 頁面使用中文說明，包含功能摘要、安裝方式與截圖。
- 讓 README 能清楚引導使用者到 GitHub Releases 下載穩定版本。

**Non-Goals:**

- 不處理 Apple Developer ID 簽章與 notarization。
- 不新增自動產生截圖的流程。
- 不變更應用程式功能或 UI。

## Decisions

### 以 package_release.sh 統一產生 zip 與 dmg

保留既有 `build_app.sh` 作為 `.app` 組裝入口，將發版產物集中在 `package_release.sh` 生成，避免 workflow 與本地發版走不同腳本。

### 以 hdiutil 建立唯讀 dmg

使用 macOS 內建 `hdiutil create` 產生可散佈的唯讀 `.dmg`，不引入額外相依工具，讓 GitHub macOS runner 與本機流程一致。

### 以 tag 驅動 GitHub Release workflow

新增 `.github/workflows/release.yml`，在 `v*` tag push 時建置、打包、蒐集 `release-notes/<tag>.md` 作為 release body，並上傳 `.zip` 與 `.dmg` 作為 release assets。

### 中文 release notes 直接作為 GitHub Release body

將版本說明檔改為中文，並使用 repository 預設 branch 上的截圖路徑，確保 release 頁面能穩定顯示圖片與下載說明。

## Risks / Trade-offs

- [未 notarize 的 macOS app 仍可能出現系統警告] → 在 release notes 明確說明這是 ad-hoc signed build，首次開啟可能需要手動允許。
- [release-notes 檔名與 tag 不一致會導致 release body 缺失] → workflow 顯式檢查 `release-notes/${tag}.md` 是否存在，缺少時直接失敗。
- [dmg 建立流程若依賴當前目錄結構，日後改動容易壞] → 腳本使用明確的 staging 目錄與絕對路徑，避免隱式假設。
