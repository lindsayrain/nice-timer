import AppKit
import SwiftUI

struct MenuBarTimerView: View {
    @EnvironmentObject private var timer: TimerModel
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Label(timer.modeDescription, systemImage: timer.menuBarIconName)
                        .font(.system(size: 13, weight: .semibold))

                    Text(timer.displayedTime.compactText)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .monospacedDigit()
                }

                Spacer(minLength: 16)

                Button {
                    openMainWindow()
                } label: {
                    Image(systemName: "macwindow")
                }
                .buttonStyle(.borderless)
                .help("打開主視窗")
            }

            Picker("模式", selection: Binding(
                get: { timer.mode },
                set: { timer.setMode($0) }
            )) {
                ForEach(TimerMode.allCases) { mode in
                    Text(mode.title).tag(mode)
                }
            }
            .pickerStyle(.segmented)

            if timer.mode == .countdown {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        DurationStepper(title: "時", value: Binding(
                            get: { timer.hours },
                            set: { timer.updateDuration(hours: $0) }
                        ), range: 0...99)

                        DurationStepper(title: "分", value: Binding(
                            get: { timer.minutes },
                            set: { timer.updateDuration(minutes: $0) }
                        ), range: 0...59)

                        DurationStepper(title: "秒", value: Binding(
                            get: { timer.seconds },
                            set: { timer.updateDuration(seconds: $0) }
                        ), range: 0...59)
                    }
                    .disabled(!timer.canEditDuration)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                        PresetChip(title: "5 分", seconds: 5 * 60)
                        PresetChip(title: "15 分", seconds: 15 * 60)
                        PresetChip(title: "25 分", seconds: 25 * 60)
                        PresetChip(title: "45 分", seconds: 45 * 60)
                    }
                    .disabled(!timer.canEditDuration)
                }
            }

            HStack(spacing: 10) {
                Button("重設") {
                    timer.reset()
                }
                .frame(maxWidth: .infinity)

                Button(timer.isRunning ? "暫停" : "開始") {
                    timer.toggleRunning()
                }
                .frame(maxWidth: .infinity)
                .tint(.green)
                .keyboardShortcut(.defaultAction)
            }
            .buttonStyle(.borderedProminent)

            Text(timer.statusText)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(timer.didFinish ? Color.orange : .secondary)
                .lineLimit(2)
        }
        .padding(14)
        .frame(width: 320)
    }

    private func openMainWindow() {
        openWindow(id: NiceTimerApp.mainWindowID)
        NSApp.activate(ignoringOtherApps: true)
    }
}

private struct DurationStepper: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)

            Stepper(value: $value, in: range) {
                Text("\(value)")
                    .monospacedDigit()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .labelsHidden()
            .overlay(alignment: .leading) {
                Text(String(format: "%02d", value))
                    .monospacedDigit()
                    .padding(.leading, 8)
                    .allowsHitTesting(false)
            }
            .padding(.horizontal, 8)
            .frame(height: 32)
            .background(Color.primary.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
        }
    }
}

private struct PresetChip: View {
    @EnvironmentObject private var timer: TimerModel
    let title: String
    let seconds: Int

    var body: some View {
        Button(title) {
            timer.applyPreset(seconds)
        }
        .buttonStyle(.bordered)
    }
}
