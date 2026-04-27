import AppKit
import XCTest
@testable import NiceTimer

@MainActor
final class TimerModelTests: XCTestCase {
    func testCountdownStateStaysSharedAcrossDisplays() {
        let timer = TimerModel()

        XCTAssertEqual(timer.displayedTime.compactText, "25:00")
        XCTAssertEqual(timer.menuBarTitle, "25:00")

        timer.applyPreset(5 * 60)

        XCTAssertEqual(timer.displayedTime.compactText, "05:00")
        XCTAssertEqual(timer.menuBarTitle, "05:00")

        timer.start()
        timer.advance(by: 2)

        XCTAssertEqual(timer.displayedTime.compactText, "04:58")
        XCTAssertEqual(timer.menuBarTitle, "04:58")
        XCTAssertEqual(timer.modeDescription, "倒數中")
    }

    func testStopwatchStateStaysSharedAcrossDisplays() {
        let timer = TimerModel()

        timer.setMode(.stopwatch)

        XCTAssertEqual(timer.displayedTime.compactText, "00:00")
        XCTAssertEqual(timer.menuBarTitle, "00:00")

        timer.start()
        timer.advance(by: 3)

        XCTAssertEqual(timer.displayedTime.compactText, "00:03")
        XCTAssertEqual(timer.menuBarTitle, "00:03")
        XCTAssertEqual(timer.modeDescription, "碼錶執行中")
    }

    func testMenuBarControlsSupportStartPauseResumeAndReset() {
        let timer = TimerModel()

        timer.applyPreset(60)
        timer.toggleRunning()

        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.statusText, "倒數中")

        timer.advance(by: 10)
        timer.toggleRunning()

        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.currentSeconds, 50)
        XCTAssertEqual(timer.statusText, "已暫停")

        timer.toggleRunning()
        timer.advance(by: 5)

        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.currentSeconds, 45)

        timer.reset()

        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.currentSeconds, 60)
        XCTAssertEqual(timer.statusText, "設定時間後按開始")
    }

    func testAppStaysActiveAfterLastWindowCloses() {
        let appDelegate = AppDelegate()
        let application = NSApplication.shared

        XCTAssertFalse(appDelegate.applicationShouldTerminateAfterLastWindowClosed(application))

        let timer = TimerModel()
        timer.setMode(.stopwatch)
        timer.start()
        timer.advance(by: 1)

        XCTAssertEqual(timer.menuBarTitle, "00:01")
        XCTAssertTrue(timer.isRunning)
    }
}
