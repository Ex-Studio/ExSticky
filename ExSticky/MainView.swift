import Cocoa

class MainView: NSView {
    // MARK: - View

    convenience init() {
        self.init(frame: .zero) // will extent to the size of parent window

        AddTextView()
    }

    // MARK: - Subviews

    private var textView: NSTextView!
    private func AddTextView() {
        let scrollView = NSTextView.scrollableTextView()
        textView = scrollView.documentView as? NSTextView

        textView.drawsBackground = false // transparent
        textView.isRichText = false
        textView.string = ""
        textView.font = NSFont(name: "SF Mono", size: 24)
        textView.usesFontPanel = true // user can change font and size in Font menu
        textView.usesFindPanel = true
        textView.allowsUndo = true

        textView.selectedTextAttributes = [NSAttributedString.Key.backgroundColor: NSColor(hex: 0x66CCFF, alpha: 0.2)]

        self.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
