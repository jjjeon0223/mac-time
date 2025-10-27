# Mac Time Remaining

A simple macOS menu bar application that displays the remaining time in the current day.

## Features

- **Menu Bar Display**: Shows time remaining in the menu bar
- **Two Display Modes**:
  - **Time Remaining**: Shows hours and minutes remaining (HH:MM format)
  - **Percentage**: Shows percentage of day remaining (e.g., "45.8%")
- **Auto Updates**: Updates every second for accurate display
- **Lightweight**: Runs as a menu bar app with minimal resource usage

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building)

## Installation

### Building from Source

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd mac-time
   ```

2. Open the Xcode project:
   ```bash
   open MacTimeRemaining/MacTimeRemaining.xcodeproj
   ```

3. Build and run the application:
   - Select the "MacTimeRemaining" scheme
   - Press `Cmd + R` to build and run
   - Or use Product > Run from the menu

4. The app will appear in your menu bar (top-right of screen)

## Usage

### Changing Display Mode

1. Click on the time display in the menu bar
2. Choose your preferred display mode:
   - **Time Remaining (HH:MM)**: Shows remaining hours and minutes (e.g., "15:42")
   - **Percentage Remaining**: Shows percentage of day left (e.g., "65.4%")

### Example Displays

At 2:30 PM (14:30):
- **Time Mode**: Shows "09:30" (9 hours 30 minutes until midnight)
- **Percentage Mode**: Shows "39.6%" (39.6% of the day remaining)

At 10:00 PM (22:00):
- **Time Mode**: Shows "02:00" (2 hours until midnight)
- **Percentage Mode**: Shows "8.3%" (8.3% of the day remaining)

## How It Works

The app calculates the time remaining until midnight (00:00) each day:

- **Time Remaining Mode**: Displays in HH:MM format
- **Percentage Mode**: Calculates remaining seconds / total seconds in day × 100

The display updates every second to ensure accuracy.

## Menu Options

- **Display Mode**: Section showing available display modes
- **Time Remaining (HH:MM)**: Switch to time-based display
- **Percentage Remaining**: Switch to percentage-based display
- **Quit**: Close the application

## Technical Details

- Built with Swift and AppKit
- Uses `NSStatusItem` for menu bar integration
- Runs as a menu bar app (no dock icon) via `LSUIElement`
- Settings are persisted using `UserDefaults`

## License

This project is open source and available under the MIT License.
