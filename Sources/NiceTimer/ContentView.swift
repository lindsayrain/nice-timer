import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var timer: TimerModel
    @State private var previousTime = TimeParts(totalSeconds: 25 * 60)

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 0) {
                TitleBar()

                VStack(spacing: 30) {
                    modePicker

                    FlipClock(time: timer.displayedTime)
                        .padding(.horizontal, 36)

                    Text(timer.statusText)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(timer.didFinish ? Color.timerWarning : Color.timerMuted)
                        .frame(height: 26)
                        .contentTransition(.opacity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                ControlPanel()
            }
        }
        .preferredColorScheme(.dark)
    }

    private var modePicker: some View {
        Picker("模式", selection: Binding(
            get: { timer.mode },
            set: { timer.setMode($0) }
        )) {
            ForEach(TimerMode.allCases) { mode in
                Text(mode.title).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .frame(width: 220)
        .controlSize(.large)
    }
}

private struct TitleBar: View {
    var body: some View {
        HStack {
            Text("Nice Timer")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(Color.timerMuted)
                .padding(.leading, 80)

            Spacer()

            Button {
                NSApp.keyWindow?.toggleFullScreen(nil)
            } label: {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
            }
            .buttonStyle(.plainIcon)
            .help("切換全螢幕")
            .padding(.trailing, 18)
        }
        .frame(height: 56)
        .background(.white.opacity(0.035))
        .overlay(alignment: .bottom) {
            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
        }
    }
}

private struct ControlPanel: View {
    @EnvironmentObject private var timer: TimerModel

    var body: some View {
        VStack(spacing: 18) {
            HStack(spacing: 12) {
                DurationField(title: "小時", value: Binding(
                    get: { timer.hours },
                    set: { timer.updateDuration(hours: $0) }
                ), range: 0...99)
                DurationField(title: "分鐘", value: Binding(
                    get: { timer.minutes },
                    set: { timer.updateDuration(minutes: $0) }
                ), range: 0...59)
                DurationField(title: "秒", value: Binding(
                    get: { timer.seconds },
                    set: { timer.updateDuration(seconds: $0) }
                ), range: 0...59)
            }
            .disabled(!timer.canEditDuration)
            .opacity(timer.canEditDuration ? 1 : 0.45)

            HStack(spacing: 10) {
                PresetButton(title: "5 分", seconds: 5 * 60)
                PresetButton(title: "15 分", seconds: 15 * 60)
                PresetButton(title: "25 分", seconds: 25 * 60)
                PresetButton(title: "45 分", seconds: 45 * 60)
            }
            .disabled(!timer.canEditDuration)
            .opacity(timer.canEditDuration ? 1 : 0.45)

            HStack(spacing: 12) {
                Button("重設") {
                    timer.reset()
                }
                .buttonStyle(.secondaryAction)
                .keyboardShortcut("r", modifiers: [])

                Button(timer.isRunning ? "暫停" : "開始") {
                    timer.toggleRunning()
                }
                .buttonStyle(.primaryAction)
                .keyboardShortcut(.space, modifiers: [])
            }
        }
        .padding(.horizontal, 42)
        .padding(.vertical, 26)
        .frame(maxWidth: .infinity)
        .background(.black.opacity(0.24))
        .overlay(alignment: .top) {
            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
        }
    }
}

private struct DurationField: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(Color.timerMuted)

            Stepper(value: $value, in: range) {
                Text("\(value)")
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .frame(maxWidth: .infinity)
            }
            .controlSize(.large)
            .padding(.horizontal, 12)
            .frame(height: 48)
            .background(Color.timerPanelStrong, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.12), lineWidth: 1)
            }
        }
    }
}

private struct PresetButton: View {
    @EnvironmentObject private var timer: TimerModel
    let title: String
    let seconds: Int

    var body: some View {
        Button(title) {
            timer.applyPreset(seconds)
        }
        .buttonStyle(.secondaryAction)
    }
}

private struct FlipClock: View {
    let time: TimeParts

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            TimeUnit(value: time.hours, label: "HRS")
            Separator()
            TimeUnit(value: time.minutes, label: "MIN")
            Separator()
            TimeUnit(value: time.seconds, label: "SEC")
        }
    }
}

private struct TimeUnit: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                ForEach(Array(value.enumerated()), id: \.offset) { _, digit in
                    FlipDigitView(value: String(digit))
                }
            }

            Text(label)
                .font(.system(size: 11, weight: .black))
                .foregroundStyle(Color.timerMuted)
                .tracking(0.8)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct FlipDigitView: View {
    let value: String
    @State private var displayedValue: String = "0"
    @State private var previousValue: String = "0"
    @State private var topRotation = 0.0
    @State private var bottomRotation = 90.0

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            ZStack {
                DigitBackground()

                Text(displayedValue)
                    .digitText(size: size)

                VStack(spacing: 0) {
                    DigitHalf(value: previousValue, size: size, isTop: true)
                        .rotation3DEffect(.degrees(topRotation), axis: (x: 1, y: 0, z: 0), anchor: .bottom, perspective: 0.55)
                    Spacer(minLength: 0)
                }

                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    DigitHalf(value: displayedValue, size: size, isTop: false)
                        .rotation3DEffect(.degrees(bottomRotation), axis: (x: 1, y: 0, z: 0), anchor: .top, perspective: 0.55)
                }

                Rectangle()
                    .fill(.black.opacity(0.62))
                    .frame(height: 1)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.36), radius: 18, x: 0, y: 12)
            .onAppear {
                displayedValue = value
                previousValue = value
            }
            .onChange(of: value) { _, newValue in
                animateChange(to: newValue)
            }
        }
        .aspectRatio(0.66, contentMode: .fit)
    }

    private func animateChange(to nextValue: String) {
        guard nextValue != displayedValue else { return }
        previousValue = displayedValue
        topRotation = 0
        bottomRotation = 90

        withAnimation(.easeIn(duration: 0.18)) {
            topRotation = -90
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            displayedValue = nextValue
            withAnimation(.easeOut(duration: 0.22)) {
                bottomRotation = 0
            }
        }
    }
}

private struct DigitHalf: View {
    let value: String
    let size: CGSize
    let isTop: Bool

    var body: some View {
        ZStack(alignment: isTop ? .top : .bottom) {
            Rectangle()
                .fill(isTop ? Color.timerTileTop : Color.timerTileBottom)
            Text(value)
                .digitText(size: size)
                .frame(width: size.width, height: size.height)
                .offset(y: isTop ? size.height / 4 : -size.height / 4)
        }
        .frame(width: size.width, height: size.height / 2)
        .clipped()
    }
}

private struct DigitBackground: View {
    var body: some View {
        VStack(spacing: 0) {
            Color.timerTileTop
            Color.timerTileBottom
        }
    }
}

private struct Separator: View {
    var body: some View {
        Text(":")
            .font(.system(size: 84, weight: .black, design: .rounded))
            .foregroundStyle(Color.timerAccent)
            .padding(.bottom, 26)
            .frame(width: 28)
    }
}

private struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.07, blue: 0.08),
                Color(red: 0.10, green: 0.10, blue: 0.11),
                Color(red: 0.05, green: 0.08, blue: 0.07)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private extension View {
    func digitText(size: CGSize) -> some View {
        self
            .font(.system(size: min(size.height * 0.74, 132), weight: .black, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(Color.timerText)
            .minimumScaleFactor(0.5)
    }
}

private extension Color {
    static let timerAccent = Color(red: 0.31, green: 0.76, blue: 0.63)
    static let timerMuted = Color(red: 0.66, green: 0.69, blue: 0.74)
    static let timerPanelStrong = Color(red: 0.14, green: 0.16, blue: 0.20)
    static let timerText = Color(red: 0.96, green: 0.94, blue: 0.89)
    static let timerTileTop = Color(red: 0.17, green: 0.19, blue: 0.23)
    static let timerTileBottom = Color(red: 0.09, green: 0.10, blue: 0.13)
    static let timerWarning = Color(red: 1.0, green: 0.79, blue: 0.40)
}

private extension ButtonStyle where Self == PrimaryActionButtonStyle {
    static var primaryAction: PrimaryActionButtonStyle { PrimaryActionButtonStyle() }
}

private extension ButtonStyle where Self == SecondaryActionButtonStyle {
    static var secondaryAction: SecondaryActionButtonStyle { SecondaryActionButtonStyle() }
}

private extension ButtonStyle where Self == PlainIconButtonStyle {
    static var plainIcon: PlainIconButtonStyle { PlainIconButtonStyle() }
}

private struct PrimaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .black))
            .foregroundStyle(Color(red: 0.03, green: 0.08, blue: 0.07))
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(configuration.isPressed ? Color.timerAccent.opacity(0.82) : Color.timerAccent, in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct SecondaryActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .bold))
            .foregroundStyle(Color.timerText)
            .frame(maxWidth: .infinity, minHeight: 46)
            .background(Color.white.opacity(configuration.isPressed ? 0.16 : 0.09), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct PlainIconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Color.timerMuted)
            .frame(width: 38, height: 38)
            .background(Color.white.opacity(configuration.isPressed ? 0.14 : 0), in: RoundedRectangle(cornerRadius: 8))
    }
}
