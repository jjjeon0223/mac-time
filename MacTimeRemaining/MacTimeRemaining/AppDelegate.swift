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
        let totalSecondsInDay: TimeInterval = 24 * 60 * 60
        let percentageRemaining = (remainingSeconds / totalSecondsInDay) * 100

        let displayMode = getDisplayMode()
        let displayText: String

        switch displayMode {
        case .timeRemaining:
            let hours = Int(remainingSeconds) / 3600
            let minutes = (Int(remainingSeconds) % 3600) / 60
            displayText = String(format: "%02d:%02d", hours, minutes)

        case .percentage:
            displayText = String(format: "%.1f%%", percentageRemaining)
        }

        if let button = statusItem.button {
            // Create pie chart icon
            let pieImage = createPieChartImage(percentage: percentageRemaining)
            button.image = pieImage
            button.imagePosition = .imageLeading
            button.title = " " + displayText
        }
    }

    private func createPieChartImage(percentage: Double) -> NSImage {
        let size: CGFloat = 18
        let image = NSImage(size: NSSize(width: size, height: size))

        image.lockFocus()

        // Create circle path
        let rect = NSRect(x: 1, y: 1, width: size - 2, height: size - 2)
        let circlePath = NSBezierPath(ovalIn: rect)

        // Draw background circle (empty/used portion)
        NSColor.systemGray.withAlphaComponent(0.3).setFill()
        circlePath.fill()

        // Draw filled pie chart (remaining portion)
        if percentage > 0 {
            let piePath = NSBezierPath()
            let center = NSPoint(x: size / 2, y: size / 2)
            let radius = (size - 2) / 2

            // Start angle at 12 o'clock (90 degrees) and go clockwise
            let startAngle: CGFloat = 90
            let endAngle = startAngle - CGFloat(percentage * 3.6) // 360 degrees * (percentage / 100)

            piePath.move(to: center)
            piePath.line(to: NSPoint(x: center.x, y: center.y + radius))
            piePath.appendArc(
                withCenter: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )
            piePath.close()

            // Color based on percentage remaining
            let color: NSColor
            if percentage > 50 {
                color = NSColor.systemGreen
            } else if percentage > 25 {
                color = NSColor.systemYellow
            } else {
                color = NSColor.systemRed
            }
            color.setFill()
            piePath.fill()
        }

        // Draw outline
        NSColor.black.withAlphaComponent(0.3).setStroke()
        circlePath.lineWidth = 0.5
        circlePath.stroke()

        image.unlockFocus()

        return image
    }
}
