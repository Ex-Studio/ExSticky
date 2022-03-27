import Cocoa

class BehaviorPreferenceVC: NSViewController {
    override func loadView() {
        view = {
            let v = NSView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.systemGreen.cgColor
            return v
        }()
    }
}
