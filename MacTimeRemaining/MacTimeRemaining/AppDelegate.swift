import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private let defaults = UserDefaults.standard
    private let displayModeKey = "displayMode"

    enum DisplayMode: String {
        case timeRemaining = "time"
        case percentage = "percentage"
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("App launching...")

        // Create status item in menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.isVisible = true

        print("Status item created: \(statusItem)")

        if let button = statusItem.button {
            button.title = "⏰"
            print("Button created with initial title")
        } else {
            print("ERROR: Could not get status item button!")
        }

        // Setup menu
        setupMenu()

        // Initial update
        updateStatusBar()

        // Update every second for accurate display
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateStatusBar()
        }

        print("App initialization complete")
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    private func setupMenu() {
        let menu = NSMenu()

        // Display mode selection
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Display Mode", action: nil, keyEquivalent: "")

        let timeItem = NSMenuItem(title: "Time Remaining (HH:MM)", action: #selector(setTimeMode), keyEquivalent: "")
        timeItem.target = self
        timeItem.state = getDisplayMode() == .timeRemaining ? .on : .off
        menu.addItem(timeItem)

        let percentageItem = NSMenuItem(title: "Percentage Remaining", action: #selector(setPercentageMode), keyEquivalent: "")
        percentageItem.target = self
        percentageItem.state = getDisplayMode() == .percentage ? .on : .off
        menu.addItem(percentageItem)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

        statusItem.menu = menu
    }

    @objc private func setTimeMode() {
        defaults.set(DisplayMode.timeRemaining.rawValue, forKey: displayModeKey)
        setupMenu()
        updateStatusBar()
    }

    @objc private func setPercentageMode() {
        defaults.set(DisplayMode.percentage.rawValue, forKey: displayModeKey)
        setupMenu()
        updateStatusBar()
    }

    private func getDisplayMode() -> DisplayMode {
        if let modeString = defaults.string(forKey: displayModeKey),
           let mode = DisplayMode(rawValue: modeString) {
            return mode
        }
        return .timeRemaining
    }

    private func updateStatusBar() {
        let now = Date()
        let calendar = Calendar.current

        // Get start and end of today
        let startOfDay = calendar.startOfDay(for: now)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) else {
            return
        }

        // Calculate remaining time
        let remainingSeconds = endOfDay.timeIntervalSince(now)

        let displayMode = getDisplayMode()
        let displayText: String

        switch displayMode {
        case .timeRemaining:
            let hours = Int(remainingSeconds) / 3600
            let minutes = (Int(remainingSeconds) % 3600) / 60
            displayText = String(format: "%02d:%02d", hours, minutes)

        case .percentage:
            let totalSecondsInDay: TimeInterval = 24 * 60 * 60
            let percentage = (remainingSeconds / totalSecondsInDay) * 100
            displayText = String(format: "%.1f%%", percentage)
        }

        if let button = statusItem.button {
            button.title = displayText
        }
    }
}
