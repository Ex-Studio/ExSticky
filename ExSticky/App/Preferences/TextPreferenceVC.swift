import Cocoa

class TextPreferenceVC: NSViewController {
    override func loadView() {
        view = {
            let v = NSView(frame: NSRect(x: 0, y: 0, width: 100, height: 400))
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.systemOrange.cgColor
            return v
        }()
    }
}
