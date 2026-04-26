import SwiftUI

@main
struct NiceTimerApp: App {
    static let mainWindowID = "main-window"

    @StateObject private var timer = TimerModel()
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup(id: Self.mainWindowID) {
            ContentView()
                .environmentObject(timer)
                .frame(minWidth: 760, minHeight: 560)
        }
        .windowStyle(.hiddenTitleBar)

        MenuBarExtra {
            MenuBarTimerView()
                .environmentObject(timer)
        } label: {
            Label(timer.menuBarTitle, systemImage: timer.menuBarIconName)
        }
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

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }
}
