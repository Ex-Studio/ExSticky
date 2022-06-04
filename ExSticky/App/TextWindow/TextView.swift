import Cocoa

class TextView: NSView {
    // MARK: - View

    convenience init(color: TextWindowColor) {
        self.init(frame: .zero) // will extent to the size of parent window

        AddTextView(color: color)
    }

    // MARK: - Subviews

    public var textView: NSTextView!
    private var scrollView: NSScrollView!
    private func AddTextView(color: TextWindowColor) {
        scrollView = NSTextView.scrollableTextView()
        textView = scrollView.documentView as? NSTextView

        textView.drawsBackground = false // transparent
        textView.isRichText = false
        
        if UserData.times == 0 {
            textView.string = String(localized: "HELP_INFO")
        } else if UserData.times % C.SUPPORT_INFO_FREQUENCY == 0 && UserData.did_open_support == false {
            textView.string = String(localized: "You have created \(UserData.times) stickies with ExSticky.\n") + String(localized: "Would you want to buy a cup of coffee for the developer?\n") + String(localized: "Help > Support\n\n")
            // TODO: 购买之后就没有这个机制了
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
