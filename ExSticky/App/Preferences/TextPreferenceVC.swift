import Cocoa
import SwiftUI
import XCLog

class TextPreferenceVC: NSHostingController<TextPreferenceView> {
    convenience init() {
        self.init(rootView: TextPreferenceView())
    }
}

struct TextPreferenceView: View {
    @State var textSize_string = "\(UserPreferences.text.size)"
    @State var textFont_string = "\(UserPreferences.text.font)"

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
                    if let receivedValue = Int(textSize_string), receivedValue >= 12, receivedValue <= 72 {
                        UserPreferences.text.size = receivedValue
                    } else {
                        XCLog(.error)
                        alertMessage = "please input correct font size"
                        presentAlert = true
                        XCLog(.error, "cannot convert")
                    }
                }
                Text("min 12 max 72 default 24")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))
            }
            Group {
                
                TextField("Font", text: $textFont_string) {
                    if NSFontManager.shared.availableFonts.contains(textFont_string)  {
                        UserPreferences.text.font = textFont_string
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
