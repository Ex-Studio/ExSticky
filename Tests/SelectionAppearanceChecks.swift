import Cocoa

// Compile with the app sources except AppDelegate.swift, and the project's XCLog dependency.
@main
struct SelectionAppearanceChecks {
    static func luminance(_ color: NSColor) -> CGFloat {
        let rgb = color.usingColorSpace(.sRGB)!
        func linear(_ c: CGFloat) -> CGFloat {
            c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linear(rgb.redComponent) + 0.7152 * linear(rgb.greenComponent) + 0.0722 * linear(rgb.blueComponent)
    }

    static func contrast(_ a: NSColor, _ b: NSColor) -> CGFloat {
        let y1 = luminance(a), y2 = luminance(b)
        return (max(y1, y2) + 0.05) / (min(y1, y2) + 0.05)
    }

    static func hex(_ color: NSColor) -> String {
        let rgb = color.usingColorSpace(.sRGB)!
        return String(format: "#%02X%02X%02X", Int((rgb.redComponent * 255).rounded()),
                      Int((rgb.greenComponent * 255).rounded()), Int((rgb.blueComponent * 255).rounded()))
    }

    static func main() {
        if let rawMode = CommandLine.arguments.first(where: { $0.hasPrefix("--expect-mode=") })?.split(separator: "=").last {
            precondition(UserSettings.text.selectionTextColor.rawValue == rawMode)
            return
        }
        _ = NSApplication.shared
        var count = 0
        var minimum: CGFloat = .greatestFiniteMagnitude
        for h in 0..<12 {
            for s: CGFloat in [0, 0.25, 0.5, 0.75, 1] {
                for b: CGFloat in [0.1, 0.4, 0.7, 1] {
                    for alpha: CGFloat in [0.2, 0.6, 1] {
                        let note = NSColor(colorSpace: .sRGB, hue: CGFloat(h) / 12, saturation: s, brightness: b, alpha: alpha)
                        for mode in ExStickySelectionTextColor.allCases {
                            let palette = ExStickySelectionPalette(noteColor: note, mode: mode)
                            minimum = min(minimum, contrast(palette.background, palette.foreground))
                            precondition(palette.background.alphaComponent == 1 && palette.foreground.alphaComponent == 1)
                            if mode == .white { precondition(palette.foreground == .white) }
                            if mode == .black { precondition(palette.foreground == .black) }
                            if alpha < 0.6 && mode == .automatic {
                                precondition(palette.background == ExStickySelectionPalette(noteColor: note, mode: .white).background)
                            }
                            count += 1
                        }
                    }
                }
            }
        }
        precondition(count == 2160 && minimum > 10)
        print(String(format: "%d palette combinations passed; minimum text contrast %.2f:1", count, minimum))
        let expected = [("#5A302E", "#FCF6F5"), ("#4B391E", "#FCF9F4"), ("#443C1B", "#FCFBF4"),
                        ("#234327", "#F5FCF6"), ("#D9EBFF", "#1D2229")]
        for (preset, pair) in zip(ExStickyPresetColor.allCases, expected) {
            let note = NSColor(hex: preset.rawValue, alpha: 1)
            let palette = ExStickySelectionPalette(noteColor: note, mode: .automatic)
            precondition(hex(palette.background) == pair.0 && hex(palette.foreground) == pair.1)
            precondition(contrast(note, palette.background) > 3)
            print("\(preset): \(hex(palette.background)) / \(hex(palette.foreground))")
        }
        // Cover a non-sRGB source and a light candidate that cannot reach Y=0.82.
        let p3 = NSColor(displayP3Red: 0.8, green: 0.2, blue: 0.9, alpha: 0.4)
        precondition(ExStickySelectionPalette(noteColor: p3, mode: .automatic).background.alphaComponent == 1)
        let blue = NSColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
        let paleBlue = ExStickySelectionPalette(noteColor: blue, mode: .black).background
        precondition(abs(paleBlue.usingColorSpace(.sRGB)!.brightnessComponent - 1) < 0.00001)
        precondition(luminance(paleBlue) < 0.82)

        let key = "exsticky.text.selectionTextColor"
        let previous = UserDefaults.standard.object(forKey: key)
        defer {
            if let previous = previous { UserDefaults.standard.set(previous, forKey: key) }
            else { UserDefaults.standard.removeObject(forKey: key) }
        }
        UserDefaults.standard.removeObject(forKey: key)
        precondition(UserSettings.text.selectionTextColor == .automatic)
        UserDefaults.standard.set("invalid", forKey: key)
        precondition(UserSettings.text.selectionTextColor == .automatic)
        for mode in ExStickySelectionTextColor.allCases {
            UserSettings.text.selectionTextColor = mode
            precondition(ExStickySettings.Text().selectionTextColor == mode)
            UserDefaults.standard.synchronize()
            let reader = Process()
            reader.executableURL = URL(fileURLWithPath: CommandLine.arguments[0])
            reader.arguments = ["--expect-mode=\(mode.rawValue)"]
            try! reader.run()
            reader.waitUntilExit()
            precondition(reader.terminationStatus == 0)
        }

        let view = TextView(color: NSColor(hex: ExStickyPresetColor.red.rawValue, alpha: 1))
        let text = view.textView!
        text.string = "选区测试 😀 abcdefghijkl"
        text.textColor = .purple
        text.textStorage!.fixAttributes(in: NSRange(location: 0, length: text.textStorage!.length))
        let original = NSAttributedString(attributedString: text.textStorage!)
        text.selectedRanges = [NSValue(range: NSRange(location: 0, length: 2)),
                               NSValue(range: NSRange(location: 7, length: 4))]
        let selections = text.selectedRanges
        precondition(selections.count == 2)
        let manager = text.layoutManager!
        for mode in ExStickySelectionTextColor.allCases {
            UserSettings.text.selectionTextColor = mode
            view.updateSelectionAppearance(isActive: true)
            let expectedPalette = ExStickySelectionPalette(noteColor: NSColor(hex: ExStickyPresetColor.red.rawValue, alpha: 1), mode: mode)
            precondition((text.selectedTextAttributes[.backgroundColor] as! NSColor) == expectedPalette.background)
            view.updateSelectionAppearance(isActive: false)
            precondition(text.selectedRanges == selections)
            for selection in selections {
                precondition(manager.temporaryAttribute(.foregroundColor, atCharacterIndex: selection.rangeValue.location, effectiveRange: nil) != nil)
            }
            view.updateSelectionAppearance(isActive: true)
            for i in 0..<text.textStorage!.length {
                precondition(manager.temporaryAttribute(.foregroundColor, atCharacterIndex: i, effectiveRange: nil) == nil)
            }
            precondition(text.textStorage!.isEqual(to: original))
        }
        view.updateSelectionAppearance(isActive: false)
        text.setSelectedRange(NSRange(location: 1, length: 0))
        view.textViewDidChangeSelection(Notification(name: NSTextView.didChangeSelectionNotification, object: text))
        for i in 0..<text.textStorage!.length {
            precondition(manager.temporaryAttribute(.foregroundColor, atCharacterIndex: i, effectiveRange: nil) == nil)
        }
        precondition(text.textStorage!.isEqual(to: original))
        text.setSelectedRange(NSRange(location: 7, length: 4))
        view.updateSelectionAppearance(isActive: false)
        text.string = "短"
        view.updateSelectionAppearance(isActive: true)
        precondition(manager.temporaryAttribute(.foregroundColor, atCharacterIndex: 0, effectiveRange: nil) == nil)

        let window = TextWindow()
        window.view.textView.string = "window selection"
        window.view.textView.setSelectedRange(NSRange(location: 0, length: 6))
        let delegate = window.delegate as! TextWindowDelegate
        let selection = window.view.textView.selectedRanges
        for alpha: Float in [0.2, 0.59, 0.6, 1] {
            let note = NSColor(hex: 0x6644AA, alpha: alpha)
            window.setColor(note)
            delegate.windowDidBecomeKey(Notification(name: NSWindow.didBecomeKeyNotification, object: window))
            let expectedPalette = ExStickySelectionPalette(noteColor: note, mode: UserSettings.text.selectionTextColor)
            precondition((window.view.textView.selectedTextAttributes[.backgroundColor] as! NSColor) == expectedPalette.background)
            delegate.windowDidResignKey(Notification(name: NSWindow.didResignKeyNotification, object: window))
            precondition(window.view.textView.selectedRanges == selection)
        }
        print("Settings fallback/relaunch, custom color/opacity refresh, multi-range focus, deselection, UTF-16 clipping, and stored text checks passed")
    }
}
