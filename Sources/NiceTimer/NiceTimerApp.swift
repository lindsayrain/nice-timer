import SwiftUI

@main
struct NiceTimerApp: App {
    @StateObject private var timer = TimerModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(timer)
                .frame(minWidth: 760, minHeight: 560)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandMenu("Timer") {
                Button(timer.isRunning ? "Pause" : "Start") {
                    timer.toggleRunning()
                }
                .keyboardShortcut(.space, modifiers: [])

                Button("Reset") {
                    timer.reset()
                }
                .keyboardShortcut("r", modifiers: [])
            }
        }
    }
}
