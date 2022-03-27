// MainView.swift

import Cocoa

class MainView: NSView {
    // MARK: - View

    convenience init() {
        self.init(frame: .zero)

        ConfigureView()

        AddLabel()
    }

    private func ConfigureView() {
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor.orange.cgColor
    }

    // MARK: - Subviews

    /// label
    let myLabel: NSView = NSTextField(labelWithString: "my label")
    private func AddLabel() {
        myLabel.frame = .init(x: 30, y: 0, width: 100, height: 20)
        myLabel.wantsLayer = true
        myLabel.layer?.backgroundColor = NSColor.green.cgColor
        self.addSubview(myLabel)
    }
}
