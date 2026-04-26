## Context

NiceTimer is currently a windowed SwiftUI macOS app. All timer interactions happen inside the main window. The timer state already lives in a shared `TimerModel`, which is a good base for exposing the same actions in a second scene.

## Goals / Non-Goals

**Goals:**

- Reuse the existing `TimerModel` as the single source of truth.
- Add a native macOS menu bar interface without duplicating timer logic.
- Keep the main window and menu bar entry synchronized.

**Non-Goals:**

- No data persistence across launches.
- No Notification Center delivery in this change.
- No extra timer modes beyond the current countdown and stopwatch behavior.

## Decisions

1. Add a `MenuBarExtra` scene in `NiceTimerApp` so the app can expose controls from the system menu bar.
2. Keep `TimerModel` shared between the window scene and the menu bar scene through `environmentObject`.
3. Use a compact menu bar layout that shows:
   - current mode
   - remaining or elapsed time
   - start/pause button
   - resume behavior through the same primary action button after pause
   - reset button
   - quick presets for countdown mode
   - action to open the main window
4. Keep the menu bar label simple, showing either an app symbol when idle or the current mm:ss value while running.
5. The menu bar scene remains available independently from the main window lifecycle so users can continue using timer controls after closing the window.

## Risks / Trade-offs

- `MenuBarExtra` layout space is limited, so the flip-card presentation should stay in the main window rather than being forced into the popover.
- Shared state across multiple scenes is straightforward here, but future persistence or notifications may require separating timing logic from UI concerns more aggressively.
