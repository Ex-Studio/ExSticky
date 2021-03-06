import Cocoa
import XCLog

class TextWindow: NSWindow {
    // MARK: - Window

    private var windowDelegate: TextWindowDelegate!

    convenience init() {
        XCLog(.trace)
        let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        self.init(
            contentRect: .zero,
            styleMask: styleMask,
            backing: .buffered,
            defer: true
        )
        self.windowDelegate = TextWindowDelegate()
        self.delegate = windowDelegate

        let color_theme = UserSettings.appearence.color_theme
        switch color_theme {
        case .single:
            var color: UInt32
            if UserSettings.appearence.openCustomizedColor == true {
                color = UserSettings.appearence.customizedColor
            } else {
                color = UserSettings.appearence.color
            }

            let alpha = UserSettings.appearence.alpha
            let window_color = NSColor(hex: color, alpha: alpha)
            ConfigureWindow(color: window_color)
            AddMainView(color: window_color)
        case .random:
            let color = ExStickyPresetColor.allCases.randomElement()!.rawValue
            let alpha = UserSettings.appearence.alpha
            let window_color = NSColor(hex: color, alpha: alpha)
            ConfigureWindow(color: window_color)
            AddMainView(color: window_color)
        }
    }

    override func close() {
        XCLog(.trace)

        let string = view.textView.string
        if string != "" {
            let c = UserData.history.count
            if c <= C.HISTORY_MAX_COUNT {
                UserData.history.append(ExStickyHistoryItem(string))
            } else {
                for _ in 0 ..< (c - C.HISTORY_MAX_COUNT) {
                    UserData.history.removeFirst()
                }
                UserData.history.append(ExStickyHistoryItem(string))
            }
        }

        super.close()
    }

    private func ConfigureWindow(color: NSColor) {
        self.setContentSize(CGSize(
            width: CGFloat(UserSettings.appearence.width),
            height: CGFloat(UserSettings.appearence.height)
        )) // default window size

        self.titlebarAppearsTransparent = true
        self.backgroundColor = NSColor(red: color.redComponent,
                                       green: color.greenComponent,
                                       blue: color.blueComponent,
                                       alpha: color.alphaComponent) // default color

        if UserSettings.behavior.float == true {
            self.level = .floating
        }

        if UserSettings.behavior.appearOnAllDesktop == true {
            self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // appear on all desktops
        }

        self.minSize = .init(width: CGFloat(C.TEXT_WINDOW_WIDTH_MIN),
                             height: CGFloat(C.TEXT_WINDOW_HEIGHT_MIN)) // include title bar
    }

    // MARK: - Views

    /// main view
    public var view: TextView!
    private func AddMainView(color: NSColor) {
        view = TextView(color: color)
        self.contentView = view
    }

    public func setColor(_ color: NSColor) {
        self.backgroundColor = color
        self.view.textView.selectedTextAttributes = [
            NSAttributedString.Key.backgroundColor: color,
        ]
    }
}
