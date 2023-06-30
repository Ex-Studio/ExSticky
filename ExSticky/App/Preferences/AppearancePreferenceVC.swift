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
    @State var presetColor = ExStickyPresetColor(rawValue: UserSettings.appearence.customizedColor) ?? .blue
    @State var isUsingCustomizedColor: Bool = UserSettings.appearence.openCustomizedColor
    @State var customizedColorHex = "\(UserSettings.appearence.customizedColor)".uint322hex

    @State var windowWidth_String = "\(UserSettings.appearence.width)"
    @State var windowHeight_String = "\(UserSettings.appearence.height)"
    @State var alpha_String = "\(UserSettings.appearence.alpha)"

    @State var alertMessage = ""
    @State var presentAlert = false

    var body: some View {
        VStack {
            Form {
                // MARK: - Window

                Group {
                    Text(String(localized: "Window Size"))
                        .font(.system(.title))

                    TextField(String(localized: "Width"), text: $windowWidth_String) {
                        if let receivedValue = Float(windowWidth_String), receivedValue >= C.TEXT_WINDOW_WIDTH_MIN {
                            UserSettings.appearence.width = receivedValue
                        } else {
                            XCLog(.error)
                            alertMessage = String(localized: "please input correct float")
                            presentAlert = true
                            XCLog(.error, String(localized: "cannot convert"))
                        }
                    }
                    TextField(String(localized: "Height"),
                              text: $windowHeight_String) {
                        if let receivedValue = Float(windowHeight_String), receivedValue >= C.TEXT_WINDOW_HEIGHT_MIN {
                            UserSettings.appearence.height = receivedValue
                        } else {
                            alertMessage = String(localized: "please input correct float")
                            presentAlert = true
                            XCLog(.error, "cannot convert")
                        }
                    }
                    Text("\(String(localized: "min")) \(Int(C.TEXT_WINDOW_WIDTH_MIN))x\(Int(C.TEXT_WINDOW_HEIGHT_MIN))  \(String(localized: "max")) \(Int(NSScreen.main!.frame.width))x\(Int(NSScreen.main!.frame.height))  \(String(localized: "default")) \(Int(C.TEXT_WINDOW_WIDTH_DEFAULT))x\(Int(C.TEXT_WINDOW_HEIGHT_DEFAULT))")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }

                // MARK: - Color

                Group {
                    Text(String(localized: "Color"))
                        .font(.system(.title))

                    TextField(String(localized: "Alpha"),
                              text: $alpha_String) {
                        if let receivedValue = Float(alpha_String),
                           receivedValue >= C.COLOR_ALPHA_MIN,
                           receivedValue <= C.COLOR_ALPHA_MAX {
                            UserSettings.appearence.alpha = receivedValue
                        } else {
                            alertMessage = String(localized: "please input correct float")
                            presentAlert = true
                            XCLog(.error, "cannot convert")
                        }
                    }
                    Text(String(localized: "min \(String(format: "%.2f", C.COLOR_ALPHA_MIN)) max \(String(format: "%.2f", C.COLOR_ALPHA_MAX)) default \(String(format: "%.2f", C.COLOR_ALPHA_DEFAULT))"))
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))

                    Picker(String(localized: "Theme"), selection: $currentColorTheme) {
                        Text(String(localized: "single"))
                            .tag(ExStickyColorTheme.single)
                        Text(String(localized: "random"))
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
                        Picker(String(localized: "Preset"), selection: $presetColor) {
                            ForEach(ExStickyPresetColor.allCases) { color in
                                switch color {
                                case .red:
                                    Text(String(localized: "Red"))
                                        .tag(color)
                                case .orange:
                                    Text(String(localized: "Orange"))
                                        .tag(color)
                                case .yellow:
                                    Text(String(localized: "Yellow"))
                                        .tag(color)
                                case .green:
                                    Text(String(localized: "Green"))
                                        .tag(color)
                                case .blue:
                                    Text(String(localized: "Blue"))
                                        .tag(color)
                                }
                            }
                        }
                        .disabled(isUsingCustomizedColor)
                        .onChange(of: presetColor) { _ in
                            UserSettings.appearence.color = presetColor.rawValue
                        }

                        Toggle(String(localized: "Use customized color"),
                               isOn: $isUsingCustomizedColor)

                        TextField(String(localized: "Customization"),
                                  text: $customizedColorHex,
                                  onCommit: {
                                      if let value = customizedColorHex.hex2uint32 {
                                          UserSettings.appearence.color = value
                                      } else {
                                          alertMessage = String(localized: "please input correct integer") // "please input correct float"
                                          presentAlert = true
                                          XCLog(.error, "cannot convert")
                                      }
                                  })
                                  .disabled(!isUsingCustomizedColor)
                        Text(String(localized: "Input the hex of your faviorite color. eg. 0x66CCFF"))
                            .foregroundColor(Color.gray)
                            .font(.system(.callout))
                    }
                    .disabled(currentColorTheme == .random)
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
