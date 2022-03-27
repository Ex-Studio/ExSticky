import Cocoa

class MainView: NSView {
    // MARK: - View

    convenience init() {
        self.init(frame: .zero) // will extent to the size of parent window

        AddTextView()
    }

    // MARK: - Subviews

    private let textView = NSTextView()
    private func AddTextView() {
        textView.isRichText = false
        textView.string = "test textView content"
        textView.drawsBackground = false
        self.addSubview(textView)

        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: self.leftAnchor),
            textView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
}
