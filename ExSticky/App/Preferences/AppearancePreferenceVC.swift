import Cocoa
import SwiftUI
import XCLog

class AppearancePreferenceVC: NSHostingController<AppearancePreferenceView> {
    convenience init() {
        self.init(rootView: AppearancePreferenceView())
    }
}

struct AppearancePreferenceView: View {
    @State var currentColorTheme: ExStickyColorTheme = UserSettings.appearence.color_theme
    @State var presetColor: ExStickyPresetColor = ExStickyPresetColor(rawValue: UserSettings.appearence.customizedColor) ?? .blue
    @State var isUsingCustomizedColor: Bool = UserSettings.appearence.openCustomizedColor
    @State var customizedColorHex = "\(UserSettings.appearence.customizedColor)".uint322hex

    @State var windowWidth_String = "\(UserSettings.appearence.width)"
    @State var windowHeight_String = "\(UserSettings.appearence.height)"
    @State var alpha_String = "\(UserSettings.appearence.alpha)"

    @State var alertMessage = ""
    @State var presentAlert = false

    var body: some View {
        Form {
            // MARK: - Window

            Group {
                Group {
                    Text("Window Size")
                        .font(.system(.title))
                    Text("The default size of a window (minimum size is 100x60).\nIt will take effect on new windows.")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
                TextField("Width", text: $windowWidth_String) {
                    if let receivedValue = Float(windowWidth_String), receivedValue > 100.0 {
                        UserSettings.appearence.width = receivedValue
                    } else {
                        XCLog(.error)
                        alertMessage = "please input correct float"
                        presentAlert = true
                        XCLog(.error, "cannot convert")
                    }
                }
                TextField("Height",
                          text: $windowHeight_String) {
                    if let receivedValue = Float(windowHeight_String), receivedValue > 60.0 {
                        UserSettings.appearence.height = receivedValue
                    } else {
                        alertMessage = "please input correct float"
                        presentAlert = true
                        XCLog(.error, "cannot convert")
                    }
                }
            }

            // MARK: - Color

            Group {
                Text("Color")
                    .font(.system(.title))

                TextField("Alpha",
                          text: $alpha_String) {
                    if let receivedValue = Float(alpha_String), receivedValue > 0.0, receivedValue <= 1.0 {
                        UserSettings.appearence.alpha = receivedValue
                    } else {
                        alertMessage = "please input correct float"
                        presentAlert = true
                        XCLog(.error, "cannot convert")
                    }
                }
                Text("The alpha value of the window, which is bigger than 0.0 and smaller than 1.0.\nIt will take effect on new windows.")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))

                Picker("Theme", selection: $currentColorTheme) {
                    Text("single")
                        .tag(ExStickyColorTheme.single)
                    Text("random")
                        .tag(ExStickyColorTheme.random)
                }
                .pickerStyle(.inline)
                .onChange(of: currentColorTheme) { newValue in
                    switch newValue {
                    case .single:
                        UserSettings.appearence.color_theme = .single
                    case .random:
                        UserSettings.appearence.color_theme = .random
                    }
                }

                // single
                Group {
                    Picker("Preset", selection: $presetColor) {
                        ForEach(ExStickyPresetColor.allCases) { color in
                            switch color {
                            case .red:
                                Text("Red")
                                    .tag(color)
                            case .orange:
                                Text("Orange")
                                    .tag(color)
                            case .yellow:
                                Text("Yellow")
                                    .tag(color)
                            case .green:
                                Text("Green")
                                    .tag(color)
                            case .blue:
                                Text("Blue")
                                    .tag(color)
                            }
                        }
                    }
                    .disabled(isUsingCustomizedColor)
                    .onChange(of: presetColor) { _ in
                        UserSettings.appearence.color = presetColor.rawValue
                    }

                    Toggle("Use customized color", isOn: $isUsingCustomizedColor)

                    TextField("Customization",
                              text: $customizedColorHex,
                              onCommit: {
                                  if let value = customizedColorHex.hex2uint32 {
                                      UserSettings.appearence.color = value
                                  } else {
                                      alertMessage = "please input correct integer" // "please input correct float"
                                      presentAlert = true
                                      XCLog(.error, "cannot convert")
                                  }
                              })
                              .disabled(!isUsingCustomizedColor)
                    Text("Input the hex of your faviorite color. eg. 0x66CCFF")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
                .disabled(currentColorTheme == .random)
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

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
// }
