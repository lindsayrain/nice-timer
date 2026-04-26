import AppKit
import Foundation

enum TimerMode: String, CaseIterable, Identifiable {
    case countdown
    case stopwatch

    var id: String { rawValue }

    var title: String {
        switch self {
        case .countdown: "倒數"
        case .stopwatch: "碼錶"
        }
    }
}

@MainActor
final class TimerModel: ObservableObject {
    @Published var mode: TimerMode = .countdown
    @Published var hours: Int = 0
    @Published var minutes: Int = 25
    @Published var seconds: Int = 0
    @Published var currentSeconds: Int = 25 * 60
    @Published var isRunning = false
    @Published var statusText = "設定時間後按開始"
    @Published var didFinish = false

    private var timer: Timer?
    private var lastTickDate: Date?

    var displayedTime: TimeParts {
        TimeParts(totalSeconds: currentSeconds)
    }

    var canEditDuration: Bool {
        mode == .countdown && !isRunning
    }

    func setMode(_ nextMode: TimerMode) {
        guard mode != nextMode else { return }
        stopTimer()
        mode = nextMode
        didFinish = false

        switch mode {
        case .countdown:
            currentSeconds = inputSeconds
            statusText = "設定時間後按開始"
        case .stopwatch:
            currentSeconds = 0
            statusText = "按開始啟動碼錶"
        }
    }

    func updateDuration(hours: Int? = nil, minutes: Int? = nil, seconds: Int? = nil) {
        guard canEditDuration else { return }
        if let hours {
            self.hours = min(max(hours, 0), 99)
        }
        if let minutes {
            self.minutes = min(max(minutes, 0), 59)
        }
        if let seconds {
            self.seconds = min(max(seconds, 0), 59)
        }
        currentSeconds = inputSeconds
        didFinish = false
        statusText = "設定時間後按開始"
    }

    func applyPreset(_ totalSeconds: Int) {
        guard canEditDuration else { return }
        hours = min(totalSeconds / 3600, 99)
        minutes = (totalSeconds % 3600) / 60
        seconds = totalSeconds % 60
        currentSeconds = inputSeconds
        didFinish = false
        statusText = "設定時間後按開始"
    }

    func toggleRunning() {
        isRunning ? pause() : start()
    }

    func start() {
        if mode == .countdown {
            let configuredSeconds = inputSeconds
            if currentSeconds <= 0 || currentSeconds != configuredSeconds {
                currentSeconds = configuredSeconds
            }

            guard currentSeconds > 0 else {
                statusText = "請先設定倒數時間"
                return
            }
        }

        didFinish = false
        isRunning = true
        lastTickDate = Date()
        statusText = mode == .countdown ? "倒數中" : "碼錶執行中"
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func pause() {
        guard isRunning else { return }
        stopTimer()
        statusText = mode == .countdown ? "已暫停" : "碼錶已暫停"
    }

    func reset() {
        stopTimer()
        didFinish = false
        switch mode {
        case .countdown:
            currentSeconds = inputSeconds
            statusText = "設定時間後按開始"
        case .stopwatch:
            currentSeconds = 0
            statusText = "按開始啟動碼錶"
        }
    }

    private var inputSeconds: Int {
        min(hours, 99) * 3600 + min(minutes, 59) * 60 + min(seconds, 59)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        lastTickDate = nil
        isRunning = false
    }

    private func tick() {
        guard let lastTickDate else { return }
        let now = Date()
        let elapsed = Int(now.timeIntervalSince(lastTickDate))
        guard elapsed > 0 else { return }
        self.lastTickDate = lastTickDate.addingTimeInterval(TimeInterval(elapsed))

        switch mode {
        case .countdown:
            currentSeconds = max(0, currentSeconds - elapsed)
            if currentSeconds == 0 {
                stopTimer()
                didFinish = true
                statusText = "時間到"
                NSSound.beep()
                NSApp.requestUserAttention(.informationalRequest)
            }
        case .stopwatch:
            currentSeconds = min(currentSeconds + elapsed, 99 * 3600 + 59 * 60 + 59)
        }
    }
}

struct TimeParts {
    let hours: String
    let minutes: String
    let seconds: String

    init(totalSeconds: Int) {
        let bounded = max(0, min(totalSeconds, 99 * 3600 + 59 * 60 + 59))
        hours = String(format: "%02d", bounded / 3600)
        minutes = String(format: "%02d", (bounded % 3600) / 60)
        seconds = String(format: "%02d", bounded % 60)
    }
}
