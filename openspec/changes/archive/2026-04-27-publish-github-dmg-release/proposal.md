## Why

目前專案只有本地 `zip` 打包腳本，GitHub 上沒有穩定可下載的 macOS 安裝檔，也沒有清楚的中文版本說明與截圖，使用者很難判斷該下載哪個版本並完成安裝。

現在需要把發版流程做成可重複執行的 GitHub release，讓每個版本都能提供明確的下載入口、可直接掛載安裝的 `.dmg` 檔，以及面向中文使用者的 release 介紹內容。

## What Changes

- 新增可產出 macOS `.dmg` 安裝映像檔的發版打包流程。
- 新增 GitHub Actions 發版 workflow，在推送版本 tag 時自動建置 app、產出 release assets、建立或更新 GitHub Release。
- 將 release 說明整理成中文格式，並在 release 頁面顯示截圖與安裝說明。
- 更新 README，讓 repository 首頁能直接引導使用者前往版本下載頁面。

## Capabilities

### New Capabilities

- `github-release-distribution`: 提供帶有 `.dmg` 安裝檔、中文說明與截圖的 GitHub 版本發佈能力。

### Modified Capabilities

- None.

## Impact

- Affected specs: `github-release-distribution`
- Affected code:
  - New: `.github/workflows/release.yml`, `openspec/specs/github-release-distribution/spec.md`
  - Modified: `README.md`, `scripts/package_release.sh`, `release-notes/v0.1.0.md`, `release-notes/v0.1.1.md`
  - Removed: none
