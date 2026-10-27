import Cocoa
import SwiftUI
import XCLog

class TextPreferenceVC: NSHostingController<TextPreferenceView> {
    convenience init() {
        self.init(rootView: TextPreferenceView())
    }
}

struct TextPreferenceView: View {
    @State var textSize_string = "\(UserSettings.text.size)"
    @State var textFont_string = "\(UserSettings.text.font)"
    @State private var selectionTextColor = UserSettings.text.selectionTextColor

    @State var alertMessage = ""
    @State var presentAlert = false

    var body: some View {
        VStack {
            Form {
                // MARK: - Window

                Group {
                    Text(String(localized: "Text Format"))
                        .font(.system(.title))
                    Text(String(localized: "Default display format of text.\nYou can also change the format of your contents in menu bar."))
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
                Group {
                    TextField(String(localized: "Size"), text: $textSize_string) {
                        if let receivedValue = Int(textSize_string),
                           receivedValue >= C.TEXT_SIZE_MIN,
                           receivedValue <= C.TEXT_SIZE_MAX
                        {
                            UserSettings.text.size = receivedValue
                        } else {
                            XCLog(.error)
                            alertMessage = String(localized: "please input correct font size")
                            presentAlert = true
                            XCLog(.error, "cannot convert")
                        }
                    }
                    Text("\(String(localized: "min")) \(C.TEXT_SIZE_MIN) \(String(localized: "max")) \(C.TEXT_SIZE_MAX) \(String(localized: "default")) \(C.TEXT_SIZE_DEFAULT)")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
                Group {
                    TextField(String(localized: "Font"), text: $textFont_string) {
                        if NSFontManager.shared.availableFonts.contains(textFont_string) {
                            UserSettings.text.font = textFont_string
                        } else {
                            XCLog(.error)
                            alertMessage = String(localized: "please input correct font name")
                            presentAlert = true
                            XCLog(.error, "wrong font name")
                        }
                    }
                    Text(String(localized: "default Helvetica\nCheck Font Book in your Mac to get the PostScript Name of a specific font."))
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
            }
            Text(String(localized: "Font changes will take effect on new windows."))
                .foregroundColor(Color.gray)
                .font(.system(.callout))

            Divider()
                .padding(.vertical, 8)

            VStack(alignment: .leading, spacing: 10) {
                Text(String(localized: "Selected text color"))
                    .font(.headline)
                Picker(String(localized: "Selected text color"), selection: $selectionTextColor) {
                    ForEach(ExStickySelectionTextColor.allCases) { mode in
                        Text(mode.localizedName).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .onChange(of: selectionTextColor) { mode in
                    UserSettings.text.selectionTextColor = mode
                    for case let window as TextWindow in NSApp.windows {
                        window.view.updateSelectionAppearance(isActive: window.isKeyWindow)
                    }
                }

                HStack(spacing: 8) {
                    ForEach(ExStickyPresetColor.allCases) { preset in
                        selectionPreview(preset)
                    }
                }
                Text(String(localized: "Color preview for opaque notes."))
                    .foregroundColor(.secondary)
                    .font(.callout)
            }
        }
        .padding()
        .frame(minWidth: 440)
        .alert(
            String(localized: "Alert"), isPresented: $presentAlert, presenting: alertMessage
        ) { _ in
            Button(String(localized: "OK")) {}
        } message: { message in
            Text(message)
        }
    }

    private func selectionPreview(_ preset: ExStickyPresetColor) -> some View {
        let noteColor = NSColor(hex: preset.rawValue, alpha: 1)
        let palette = ExStickySelectionPalette(noteColor: noteColor, mode: selectionTextColor)
        return VStack(spacing: 8) {
            Text(preset.localizedName)
                .font(.caption)
                .foregroundColor(.black)
            Text(String(localized: "Selected"))
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(Color(nsColor: palette.foreground))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color(nsColor: palette.background))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(nsColor: noteColor))
        .cornerRadius(6)
    }
}
