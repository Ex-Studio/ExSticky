import Cocoa

class TextView: NSView {
    // MARK: - View

    convenience init(color: TextWindowColor) {
        self.init(frame: .zero) // will extent to the size of parent window

        AddTextView(color: color)
    }

    // MARK: - Subviews

    private var textView: NSTextView!
    private func AddTextView(color: TextWindowColor) {
        let scrollView = NSTextView.scrollableTextView()
        textView = scrollView.documentView as? NSTextView

        textView.drawsBackground = false // transparent
        textView.isRichText = false
        if UserData.times == 0 {
            textView.string = "Thanks for downloading ExSticky!\n\nSeveral Usages\n- pin a sticky on your desktop\n- copy and paste pure text contents\n\nShortcuts\n- ⌘N New Window\n- ⌘, Preferences"
        } else if UserData.times % 100 == 0 {
            textView.string = "You have created \(UserData.times) stickies with ExSticky.\nWould you want to buy a cup of coffee for the developer?"
        } else {
            textView.string = ""
        }
        UserData.times += 1

        textView.font = NSFont(
            name: UserSettings.text.font,
            size: CGFloat(UserSettings.text.size)
        )
        textView.usesFontPanel = true // user can change font and size in Font menu
        textView.usesFindPanel = true
        textView.allowsUndo = true

        textView.selectedTextAttributes = [
            NSAttributedString.Key.backgroundColor:
                NSColor(hex: color.hex,
                        alpha: color.alpha),
        ]

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
