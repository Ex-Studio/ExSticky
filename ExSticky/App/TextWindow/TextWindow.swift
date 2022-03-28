import Cocoa
import XCLog

class TextWindow: NSWindow {
    // MARK: - Window

    convenience init() {
        let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        self.init(
            contentRect: .zero,
            styleMask: styleMask,
            backing: .buffered,
            defer: true
        )

        let color_theme = UserPreferences.appearence.color_theme
        switch color_theme {
        case .single:
            var color: UInt32
            if UserPreferences.appearence.openCustomizedColor == true {
                color = UserPreferences.appearence.customizedColor
            } else {
                color = UserPreferences.appearence.color
            }

            let alpha = UserPreferences.appearence.alpha
            let window_color = WindowColor(hex: color, alpha: alpha)
            ConfigureWindow(color: window_color)
            AddMainView(color: window_color)
        case .random:
            let color = PresetColor.allCases.randomElement()!.rawValue
            let alpha = UserPreferences.appearence.alpha
            let window_color = WindowColor(hex: color, alpha: alpha)
            ConfigureWindow(color: window_color)
            AddMainView(color: window_color)
        }
    }

    override func close() {
        // TODO: save content
        super.close()
        XCLog(.trace)
    }

    private func ConfigureWindow(color: WindowColor) {
        self.setContentSize(CGSize(
            width: CGFloat(UserPreferences.appearence.width),
            height: CGFloat(UserPreferences.appearence.height)
        )) // default window size

        self.titlebarAppearsTransparent = true
        self.backgroundColor = NSColor(hex: color.hex,
                                       alpha: color.alpha) // default color

        if UserPreferences.behavior.float == true {
            self.level = .floating
        }

        if UserPreferences.behavior.appearInAllDesktop == true {
            self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // appear on all desktops
        }

        self.minSize = .init(width: 100, height: 60) // include title bar
    }

    // MARK: - Views

    /// main view
    private var view: TextView!
    private func AddMainView(color: WindowColor) {
        view = TextView(color: color)
        self.contentView = view
    }
}
