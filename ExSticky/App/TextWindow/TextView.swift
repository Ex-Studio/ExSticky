import Cocoa

class TextView: NSView, NSTextViewDelegate {
    private var noteColor = NSColor.white
    private var selectionIsActive = true
    private var temporarySelectionRanges: [NSRange] = []

    func updateSelectionAppearance(noteColor: NSColor? = nil, isActive: Bool? = nil) {
        if let noteColor = noteColor { self.noteColor = noteColor }
        if let isActive = isActive { selectionIsActive = isActive }

        let textRange = NSRange(location: 0, length: (textView.string as NSString).length)
        for range in temporarySelectionRanges {
            let validRange = NSIntersectionRange(range, textRange)
            if validRange.length > 0 {
                textView.layoutManager?.removeTemporaryAttribute(.foregroundColor, forCharacterRange: validRange)
            }
        }
        temporarySelectionRanges.removeAll()

        if selectionIsActive {
            let palette = ExStickySelectionPalette(noteColor: self.noteColor, mode: UserSettings.text.selectionTextColor)
            textView.selectedTextAttributes = [
                .backgroundColor: palette.background,
                .foregroundColor: palette.foreground,
            ]
        } else {
            textView.selectedTextAttributes = [
                .backgroundColor: NSColor.unemphasizedSelectedTextBackgroundColor,
                .foregroundColor: NSColor.unemphasizedSelectedTextColor,
            ]
            // AppKit ignores selectedTextAttributes' foreground color when inactive.
            // Temporary layout attributes never alter the stored text or its color.
            for value in textView.selectedRanges {
                let range = NSIntersectionRange(value.rangeValue, textRange)
                if range.length > 0 {
                    textView.layoutManager?.addTemporaryAttribute(
                        .foregroundColor, value: NSColor.unemphasizedSelectedTextColor,
                        forCharacterRange: range
                    )
                    temporarySelectionRanges.append(range)
                }
            }
        }
        textView.needsDisplay = true
    }

    func textViewDidChangeSelection(_ notification: Notification) {
        updateSelectionAppearance()
    }

    func textDidChange(_ notification: Notification) {
        updateSelectionAppearance()
    }

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
        updateSelectionAppearance(isActive: window?.isKeyWindow ?? false)
    }

    // MARK: - View

    convenience init(color: NSColor) {
        self.init(frame: .zero) // will extent to the size of parent window

        AddTextView(color: color)
    }

    // MARK: - Subviews

    public var textView: NSTextView!
    private var scrollView: NSScrollView!
    private func AddTextView(color: NSColor) {
        scrollView = NSTextView.scrollableTextView()
        textView = scrollView.documentView as? NSTextView
        textView.delegate = self

        textView.drawsBackground = false // transparent
        textView.isRichText = false

        if UserData.times == 0 {
            textView.string = String(localized: "HELP_INFO")
        } else if UserData.times % C.SUPPORT_INFO_FREQUENCY == 0, UserData.did_open_support == false {
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

        updateSelectionAppearance(noteColor: color)

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
