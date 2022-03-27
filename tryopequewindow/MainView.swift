import Cocoa

class MainView: NSView {
    // MARK: - View

    convenience init() {
        self.init(frame: .zero) // will extent to the size of parent window

//        AddLabel()
    }

    // MARK: - Subviews

//    /// label
//    let myLabel: NSView = NSTextField(labelWithString: "my label")
//    private func AddLabel() {
//        myLabel.frame = .init(x: 30, y: 0, width: 100, height: 20)
//        myLabel.wantsLayer = true
//        myLabel.layer?.backgroundColor = NSColor.green.cgColor
//        self.addSubview(myLabel)
//    }
}
