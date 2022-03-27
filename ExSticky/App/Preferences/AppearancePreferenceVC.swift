import Cocoa

class AppearancePreferenceVC: NSViewController {
    override func loadView() {
        view = {
            let v = NSView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.systemBlue.cgColor
            return v
        }()
    }
}
