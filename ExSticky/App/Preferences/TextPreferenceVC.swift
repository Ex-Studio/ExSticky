import Cocoa
import XCLog

class TextPreferenceVC: NSViewController {
    private var label_textSize: NSTextField!
    private var slider_textSize: NSSlider!
    private var label_textFont: NSTextField!
    private var slider2: NSSlider!

    private var vstack: NSStackView!

    override func loadView() {
        view = {
            let v = NSView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.systemOrange.cgColor
            return v
        }()

        slider_textSize = {
            let s = NSSlider(value: 24, minValue: 12, maxValue: 72,
                             target: self, action: #selector(self.sliderGotNewValue(_:)))
            return s
        }()

        slider2 = {
            let s = NSSlider(value: 24, minValue: 12, maxValue: 72,
                             target: self, action: #selector(self.sliderGotNewValue(_:)))
            return s
        }()

        label_textSize = {
            let l = NSTextField(labelWithAttributedString: try! NSAttributedString(markdown: "**Default Size**"))
            return l
        }()

        label_textFont = {
            let l = NSTextField(labelWithAttributedString: try! NSAttributedString(markdown: "**Default Font**"))
            return l
        }()

        vstack = {
            let s = NSStackView()
            s.alignment = .centerX

            let hstack1 = NSStackView()
            hstack1.alignment = .centerY
            hstack1.addView(label_textSize, in: .leading)
            label_textSize.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label_textSize.widthAnchor.constraint(equalToConstant: 100)])
            hstack1.addView(slider_textSize, in: .trailing)
            s.addView(hstack1, in: .center)

            let hstack2 = NSStackView()
            hstack2.alignment = .centerY
            hstack2.addView(label_textFont, in: .leading)
            label_textFont.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([label_textFont.widthAnchor.constraint(equalToConstant: 100)])
            hstack2.addView(slider2, in: .trailing)
            s.addView(hstack1, in: .center)

            s.addView(hstack2, in: .center)

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

    @objc func sliderGotNewValue(_ sender: NSSlider!) {
        XCLog(.debug, "\(sender.doubleValue)")
    }
}
