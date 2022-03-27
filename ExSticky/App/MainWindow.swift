import Cocoa

class MainWindow: NSWindow {
    // MARK: - Window

    convenience init() {
        let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        self.init(
            contentRect: .zero,
            styleMask: styleMask,
            backing: .buffered,
            defer: true
        )

        ConfigureWindow()

        AddMainView()
    }

    override func close() {
        super.close()
        print("closed")
    }

    private func ConfigureWindow() {
        self.setContentSize(CGSize(
            width: CGFloat(UserPreferences.appearence.width),
            height: CGFloat(UserPreferences.appearence.height)
        )) // default window size

        self.titlebarAppearsTransparent = true
        self.backgroundColor = NSColor(hex: UserPreferences.appearence.color,
                                       alpha: UserPreferences.appearence.alpha) // default color

        if UserPreferences.behavior.float == true {
            self.level = .floating
        }

        if UserPreferences.behavior.appearInAllDesktop == true {
            self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary] // appear on all desktops
        }
    }

    // MARK: - Views

    /// main view
    private let mainView = MainView()
    private func AddMainView() {
        self.contentView = mainView
    }
}
