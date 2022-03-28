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
        Form {
            // MARK: - Window

            Group {
                Text("Text Format")
                    .font(.system(.title))
                Text("Default display format of text. It will take effect on new windows.\nYou can also change the format of your contents in menubar.\nChanges will take effect on new windows.")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))
            }
            Group {
                TextField("Size", text: $textSize_string) {
                    if let receivedValue = Int(textSize_string),
                       receivedValue >= C.TEXT_SIZE_MIN,
                       receivedValue <= C.TEXT_SIZE_MAX {
                        UserSettings.text.size = receivedValue
                    } else {
                        XCLog(.error)
                        alertMessage = "please input correct font size"
                        presentAlert = true
                        XCLog(.error, "cannot convert")
                    }
                }
                Text("min \(C.TEXT_SIZE_MIN) max \(C.TEXT_SIZE_MAX) default \(C.TEXT_SIZE_DEFAULT)")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))
            }
            Group {
                TextField("Font", text: $textFont_string) {
                    if NSFontManager.shared.availableFonts.contains(textFont_string) {
                        UserSettings.text.font = textFont_string
                    } else {
                        XCLog(.error)
                        alertMessage = "please input correct font name"
                        presentAlert = true
                        XCLog(.error, "wrong font name")
                    }
                }
                Text("default SFMono-Regular\nCheck your Font Book to get the postscript name of a specific font.")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))
            }
        }
        .padding()
        .alert(
            "Alert", isPresented: $presentAlert, presenting: alertMessage
        ) { _ in
            Button("OK") {}
        } message: { message in
            Text(message)
        }
    }
}
