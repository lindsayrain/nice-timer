# Nice Timer

原生 macOS SwiftUI 翻牌計時器。

![Nice Timer 主畫面](https://raw.githubusercontent.com/lindsayrain/nice-timer/main/release-assets/screenshots/main-window.png)

## 功能

- 倒數計時與碼錶模式
- 翻牌動畫顯示小時、分鐘、秒
- 5、15、25、45 分鐘快速預設
- 開始、暫停、重設、全螢幕
- 鍵盤操作：空白鍵開始/暫停，`R` 重設
- 倒數結束時播放系統提示音並要求使用者注意

## 下載安裝

- 穩定版本下載頁面：<https://github.com/lindsayrain/nice-timer/releases>
- 建議 macOS 使用者優先下載 `.dmg`，開啟後把 `NiceTimer.app` 拖到 `Applications`。
- 如果只想手動解壓，也可以下載同版本的 `.zip`。
- 目前發佈版本為 ad-hoc 簽章，第一次開啟若看到系統警告，請到「系統設定 > 隱私權與安全性」允許執行。

## 建置 `.app`

```bash
bash scripts/build_app.sh
```

建置完成後 app 會在：

```text
build/NiceTimer.app
```

## 打包發佈版本

會同時產生 `.zip` 與 `.dmg`：

```bash
bash scripts/package_release.sh 0.1.0 1
```

打包完成後產物會在：

```text
dist/NiceTimer-0.1.0.zip
dist/NiceTimer-0.1.0.dmg
```

也可以開發時直接執行：

```bash
swift run
```
