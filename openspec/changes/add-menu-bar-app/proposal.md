## Why

The current app requires a full window to be open before the user can check remaining time or start a short countdown. On macOS, a timer is often a utility app that should be reachable from the menu bar with one click.

Adding a menu bar mode makes the timer faster to access and better aligned with native macOS usage patterns.

## What Changes

- Add a menu bar entry point for NiceTimer using `MenuBarExtra`.
- Allow users to start, pause, resume, and reset a timer directly from the menu bar.
- Show current timer status and remaining time in the menu bar UI.
- Keep timer control available even when the main window is closed.
- Keep the existing windowed app available for the full flip-clock experience.

## Non-Goals (optional)

- This change does not redesign the main window UI.
- This change does not add persistence, notifications, or multi-timer support.
- This change does not move the app to a menu-bar-only architecture yet.

## Capabilities

### New Capabilities

- `timer-menubar`: Provide quick timer controls and status in the macOS menu bar.

### Modified Capabilities

- None.

## Impact

- Affected code: SwiftUI app entry, timer state model, macOS menu bar scene, command wiring.
- APIs: `MenuBarExtra`, shared observable timer state, existing timer actions.
- Dependencies: none expected beyond Apple frameworks already in use.
