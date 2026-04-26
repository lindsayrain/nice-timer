# Nice Timer

原生 macOS SwiftUI 翻牌計時器。

## 功能

- 倒數計時與碼錶模式
- 翻牌動畫顯示小時、分鐘、秒
- 5、15、25、45 分鐘快速預設
- 開始、暫停、重設、全螢幕
- 鍵盤操作：空白鍵開始/暫停，`R` 重設
- 倒數結束時播放系統提示音並要求使用者注意

## 建置 `.app`

```bash
bash scripts/build_app.sh
```

建置完成後 app 會在：

```text
build/NiceTimer.app
```

也可以開發時直接執行：

```bash
swift run
```
