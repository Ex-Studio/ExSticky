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

    private func ConfigureWindow() {
        self.setContentSize(.init(width: 400 * sqrt(2), height: 400)) // default window size
        self.titlebarAppearsTransparent = true
        self.backgroundColor = NSColor(hex: 0x66CCFF, alpha: 0.2) // default color
    }

    // MARK: - Views

    /// main view
    private let mainView = MainView()
    private func AddMainView() {
        self.contentView = mainView
    }
}
