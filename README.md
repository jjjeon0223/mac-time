# Mac Time Remaining

A simple macOS menu bar application that displays the remaining time in the current day with a visual pie chart indicator.

## Features

- **Visual Pie Chart**: Animated circular indicator that drains as the day progresses
  - Green: More than 50% of day remaining
  - Yellow: 25-50% of day remaining
  - Red: Less than 25% of day remaining
- **Menu Bar Display**: Shows time remaining in the menu bar
- **Two Display Modes**:
  - **Time Remaining**: Shows hours and minutes remaining (HH:MM format)
  - **Percentage**: Shows percentage of day remaining (e.g., "45.8%")
- **Auto Updates**: Updates every second for accurate display and smooth animation
- **Lightweight**: Runs as a menu bar app with minimal resource usage

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later (for building)

## Installation

### Option 1: Build and Install (Recommended)

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd mac-time
   ```

2. Open the Xcode project:
   ```bash
   open MacTimeRemaining/MacTimeRemaining.xcodeproj
   ```

3. Build the Release version:
   - In Xcode, go to **Product → Scheme → Edit Scheme...**
   - Select "Run" on the left
   - Change "Build Configuration" from "Debug" to "Release"
   - Click "Close"
   - Press `Cmd + B` to build

4. Locate the built app:
   - In Xcode, go to **Product → Show Build Folder in Finder**
   - Navigate to `Products/Release/`
   - You'll find `MacTimeRemaining.app`

5. Install the app:
   ```bash
   # Copy to Applications folder
   cp -r ~/Library/Developer/Xcode/DerivedData/MacTimeRemaining-*/Build/Products/Release/MacTimeRemaining.app /Applications/
   ```

   Or simply drag `MacTimeRemaining.app` from the Finder window to your Applications folder

6. Launch the app:
   - Open `MacTimeRemaining.app` from Applications
   - The app will appear in your menu bar
   - The app will continue running even after closing Xcode

### Option 2: Run from Xcode (For Development)

1. Follow steps 1-2 from Option 1
2. Press `Cmd + R` to build and run
3. The app will appear in your menu bar
4. Note: The app will quit when you stop it in Xcode

### Auto-Start on Login (Optional)

To have the app start automatically when you log in:

1. Open **System Settings** (or System Preferences)
2. Go to **General → Login Items** (or **Users & Groups → Login Items** on older macOS)
3. Click the **+** button
4. Navigate to `/Applications/` and select `MacTimeRemaining.app`
5. Click **Add**

Now the app will start automatically every time you log in!

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
- Custom pie chart rendering with `NSBezierPath` and `NSImage`
- Dynamic color coding based on time remaining
- Runs as a menu bar app (no dock icon) via `LSUIElement`
- Settings are persisted using `UserDefaults`
- Updates every second for smooth pie chart animation

## License

This project is open source and available under the MIT License.
