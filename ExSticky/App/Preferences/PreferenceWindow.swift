import Cocoa
import SwiftUI
import XCLog

class PreferencesPanel: NSWindow {
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
        self.setContentSize(CGSize(
            width: CGFloat(UserPreferences.appearence.width),
            height: CGFloat(UserPreferences.appearence.height)
        )) // default window size
        self.title = "Preferences"
    }

    // MARK: - Views

    /// main view
    private let view = NSHostingView(rootView: PreferenceView())
    private func AddMainView() {
        self.contentView = view
    }
}
