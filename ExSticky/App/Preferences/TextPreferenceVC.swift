import Cocoa
import XCLog

// TODO: border

class TextPreferenceVC: NSViewController {
    private var vstack: NSStackView!

    private var label_textSize: NSTextField!
    private var textfield_textSize: NSTextField!
    private var stepper_textSize: NSStepper!

    private var label_textFont: NSTextField!
    private var textfield_textFont: NSTextField!

    override func loadView() {
        XCLog(.trace)

        view = {
            let v = NSView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.systemOrange.cgColor
            return v
        }()

        label_textSize = {
            let l = NSTextField(labelWithAttributedString: try! NSAttributedString(markdown: "**Default Size**"))
            return l
        }()

        textfield_textSize = {
            let tf = NSTextField(labelWithString: "\(UserPreferences.text.size)")
            tf.isEditable = true
            return tf
        }()

        stepper_textSize = {
            let s = NSStepper()
            s.maxValue = 72
            s.minValue = 12
            s.increment = 1
            s.target = self
            s.action = #selector(stepper_textSize_gotNewValue(_:))
            s.autorepeat = true // 鼠标一直放上去就一直加
            s.valueWraps = false // 别循环
            return s
        }()

        textfield_textFont = {
            let tf = NSTextField(labelWithString: "\(UserPreferences.text.font)")
            tf.isEditable = true
            return tf
        }()

        label_textFont = {
            let l = NSTextField(labelWithAttributedString: try! NSAttributedString(markdown: "**Default Font**"))
            return l
        }()

        vstack = {
            let s = NSStackView()
            s.alignment = .centerX

            let hstack_textSize = NSStackView()
            hstack_textSize.alignment = .centerY
            hstack_textSize.addView(label_textSize, in: .leading)
            label_textSize.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label_textSize.widthAnchor.constraint(equalToConstant: 100)])
            hstack_textSize.addView(textfield_textSize, in: .leading)
            hstack_textSize.addView(stepper_textSize, in: .trailing)
            s.addView(hstack_textSize, in: .center)

            let hstack_textFont = NSStackView()
            hstack_textFont.alignment = .centerY
            hstack_textFont.addView(label_textFont, in: .leading)
            label_textFont.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label_textFont.widthAnchor.constraint(equalToConstant: 100)])
            hstack_textFont.addView(textfield_textFont, in: .trailing)
            s.addView(hstack_textFont, in: .center)

            return s
        }()

        view.addSubview(vstack)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vstack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vstack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vstack.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
            vstack.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20),
        ])
    }

    @objc private func stepper_textSize_gotNewValue(_ sender: NSStepper!) {
        XCLog(.debug, "\(sender.doubleValue)")
        textfield_textSize.stringValue = "\(Int(sender.doubleValue))"
    }
}
