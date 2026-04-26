## ADDED Requirements

### Requirement: Menu Bar Access

The app MUST provide a menu bar entry that exposes timer status and controls without requiring the main window to remain open.

#### Scenario: User opens timer from the menu bar

- **WHEN** the user clicks the app's menu bar item
- **THEN** the app shows a menu bar interface with the current timer state and timer actions

#### Scenario: User closes the main window

- **GIVEN** the app is running
- **WHEN** the user closes the main window
- **THEN** the menu bar entry remains available
- **AND** the user can still inspect timer state and use timer controls from the menu bar

### Requirement: Shared Timer State

The menu bar interface MUST operate on the same timer state as the main window.

#### Scenario: Menu bar starts a countdown

- **GIVEN** the main window shows a countdown duration of 25 minutes
- **WHEN** the user starts the timer from the menu bar
- **THEN** the countdown starts in both the menu bar and the main window

#### Scenario: Main window pauses a running timer

- **GIVEN** the timer is running
- **WHEN** the user pauses it from the main window
- **THEN** the menu bar interface reflects the paused state without requiring relaunch or refresh

#### Scenario: Menu bar starts stopwatch mode

- **GIVEN** the app is in stopwatch mode
- **WHEN** the user starts timing from the menu bar
- **THEN** elapsed time advances in both the menu bar and the main window

#### Scenario: Menu bar resets timer state

- **GIVEN** the timer has elapsed or partially completed time
- **WHEN** the user resets the timer from the menu bar
- **THEN** the timer returns to the correct reset state for the current mode
- **AND** the main window shows the same reset state

### Requirement: Menu Bar Timer Controls

The menu bar interface MUST support the same core timer actions needed for direct use.

#### Scenario: User pauses from the menu bar

- **GIVEN** the timer is running
- **WHEN** the user presses pause in the menu bar
- **THEN** the timer stops advancing
- **AND** the main window reflects the paused state

#### Scenario: User resumes from the menu bar

- **GIVEN** the timer is paused
- **WHEN** the user presses the primary action in the menu bar
- **THEN** the timer resumes from the paused value
- **AND** the main window reflects the resumed running state

### Requirement: Compact Countdown Presets

The menu bar interface MUST provide quick preset actions for countdown mode.

#### Scenario: User selects a preset from the menu bar

- **GIVEN** the timer is in countdown mode and not currently running
- **WHEN** the user selects a preset duration from the menu bar
- **THEN** the countdown duration updates immediately
- **AND** the main window shows the same configured duration
