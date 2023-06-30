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
                           receivedValue <= C.TEXT_SIZE_MAX {
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
                    Text(String(localized: "default SFMono-Regular\nCheck Font Book in your Mac to get the postscript name of a specific font."))
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
            }
            Divider()

            Text(String(localized: "Changes will take effect on new windows."))
                .foregroundColor(Color.gray)
                .font(.system(.callout))
        }
        .padding()
        .alert(
            String(localized: "Alert"), isPresented: $presentAlert, presenting: alertMessage
        ) { _ in
            Button(String(localized: "OK")) {}
        } message: { message in
            Text(message)
        }
    }
}
