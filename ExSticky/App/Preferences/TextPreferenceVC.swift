import Cocoa
import XCLog

// TODO: add border
// TODO: 各种sender和提示的结合

class TextPreferenceVC: NSViewController {
    private let title_width: CGFloat = 40.0
    private let space_around: CGFloat = 30.0

    private var vstack: NSStackView!

    private var label_textSize: NSTextField!
    private var textfield_textSize: NSTextField!
    private var stepper_textSize: NSStepper!
    private var label_hint_textSize: NSTextField!

    private var label_textFont: NSTextField!
    private var textfield_textFont: NSTextField!
    private var label_hint_textFont: NSTextField!

    override func loadView() {
        XCLog(.trace)

        view = {
            let v = NSView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.clear.cgColor
            return v
        }()

        label_textSize = {
            let l = NSTextField(labelWithAttributedString:
                NSAttributedString(string: "Size",
                                   attributes: [.font: NSFont.boldSystemFont(ofSize: 12.0)]))
            return l
        }()

        textfield_textSize = {
            let tf = NSTextField(labelWithString: "\(Int(UserPreferences.text.size))") // default value
            tf.isEditable = true
            tf.target = self
            tf.action = #selector(textfield_textSize_gotNewValue(_:))
            return tf
        }()

        label_hint_textSize = {
            let l = NSTextField(labelWithAttributedString:
                NSAttributedString(string: "min 12 max 72 (default 24)\nChanges will take effect on new windows.",
                                   attributes: [.foregroundColor: NSColor.systemGray]))
            l.alignment = .natural
            l.usesSingleLineMode = false
            return l
        }()

        stepper_textSize = {
            let s = NSStepper()
            s.doubleValue = Double(UserPreferences.text.size) // default value
            s.maxValue = Double(UserPreferences.text.max_size)
            s.minValue = Double(UserPreferences.text.min_size)
            s.increment = 1
            s.target = self
            s.action = #selector(stepper_textSize_gotNewValue(_:))
            s.autorepeat = true // 鼠标一直放上去就一直加
            s.valueWraps = false // 别循环
            return s
        }()

        textfield_textFont = { // TODO:
            let tf = NSTextField(labelWithString: "\(UserPreferences.text.font)")
            tf.isEditable = true
            tf.target = self
            tf.action = #selector(textfield_textFont_gotNewValue(_:))
            return tf
        }()

        label_textFont = {
            let l = NSTextField(labelWithAttributedString:
                NSAttributedString(string: "Font", attributes: [.font: NSFont.boldSystemFont(ofSize: 12)]))
            return l
        }()

        label_hint_textFont = {
            let l = NSTextField(labelWithAttributedString:
                NSAttributedString(string: "Check your Font Book to get the postscript name of a specific font.\n(default SFMono-Regular)\nChanges will take effect on new windows.",
                                   attributes: [.foregroundColor: NSColor.systemGray]))
            l.alignment = .natural
            l.usesSingleLineMode = false
            return l
        }()

        vstack = {
            let s = NSStackView()
            s.alignment = .centerX

            let hstack_textSize = NSStackView()
            hstack_textSize.alignment = .centerY
            hstack_textSize.addView(label_textSize, in: .leading)
            label_textSize.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label_textSize.widthAnchor.constraint(equalToConstant: self.title_width)])
            hstack_textSize.addView(textfield_textSize, in: .leading)
            hstack_textSize.addView(stepper_textSize, in: .trailing)
            s.addView(hstack_textSize, in: .center)

            s.addView(label_hint_textSize, in: .center)
            label_hint_textSize.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label_hint_textSize.leftAnchor.constraint(equalTo: s.leftAnchor, constant: self.title_width),
            ])

            let hstack_textFont = NSStackView()
            hstack_textFont.alignment = .centerY
            hstack_textFont.addView(label_textFont, in: .leading)
            label_textFont.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label_textFont.widthAnchor.constraint(equalToConstant: self.title_width)])
            hstack_textFont.addView(textfield_textFont, in: .trailing)
            s.addView(hstack_textFont, in: .center)

            s.addView(label_hint_textFont, in: .center)
            label_hint_textFont.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label_hint_textFont.leftAnchor.constraint(equalTo: s.leftAnchor, constant: self.title_width),
            ])

            return s
        }()

        view.addSubview(vstack)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vstack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vstack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vstack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -self.space_around),
            vstack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -self.space_around),
        ])
    }

    @objc private func stepper_textSize_gotNewValue(_ sender: NSStepper!) {
        let newValue = Int(sender.doubleValue)
        XCLog(.debug, "\(newValue)")
        textfield_textSize.stringValue = "\(newValue)"
        UserPreferences.text.size = newValue
    }

    @objc private func textfield_textSize_gotNewValue(_ sender: NSTextField!) {
        if var newValue = Int(sender.stringValue) {
            if newValue > UserPreferences.text.max_size { newValue = Int(UserPreferences.text.max_size) }
            if newValue < UserPreferences.text.min_size { newValue = Int(UserPreferences.text.min_size) }
            XCLog(.debug, "\(newValue)")
            textfield_textSize.stringValue = "\(newValue)" // 显示为整数
            stepper_textSize.doubleValue = Double(newValue)
            UserPreferences.text.size = newValue
        } else {
            XCLog(.error, "cannot convert to Int")
        }
    }

    @objc private func textfield_textFont_gotNewValue(_ sender: NSTextField!) {
        let receivedValue = sender.stringValue
        XCLog(.debug, "\(receivedValue)")
        if NSFontManager.shared.availableFonts.contains(receivedValue) {
            UserPreferences.text.font = receivedValue
        } else {
            XCLog(.error, "user don't have this font")
            textfield_textFont.stringValue = UserPreferences.text.font
            // TODO: add hints
        }
    }
}
