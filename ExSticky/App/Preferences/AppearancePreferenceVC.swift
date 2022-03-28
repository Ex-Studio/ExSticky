import Cocoa
import XCLog

class AppearancePreferenceVC: NSViewController {
    override func loadView() {
        XCLog(.trace)

        view = {
            let v = NSView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.systemBlue.cgColor
            return v
        }()
    }
}
