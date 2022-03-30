import Cocoa
import SwiftUI

class HelpWC: NSWindowController {
    private var helpVC: NSHostingController<HelpView>!

    convenience init() {
        let window: NSWindow = {
            let w = NSWindow(
                contentRect: .zero,
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: true
            )
            w.title = String(localized: "Help")
            return w
        }()
        self.init(window: window)

        helpVC = HelpVC()

        contentViewController = helpVC
    }
}
