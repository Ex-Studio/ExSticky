import Cocoa
import SwiftUI
import XCLog

class AppearancePreferenceVC: NSHostingController<ContentView> {
    convenience init() {
        self.init(rootView: ContentView())
    }
}

struct ContentView: View {
    @State var currentColorTheme: ColorTheme = .single
    @State var presetColor: ExStickyColor = .red
    @State var isUsingCustomizedColor = false
    @State var customizedColorHex = "0x66CCFF"
    @State var presentAlert_customColorCannotConvertToUInt32 = false
    @State var presentAlert_widthCannotConvertToUInt32 = false
    @State var presentAlert_heightCannotConvertToUInt32 = false

    @State var windowWidth_String = "565.7"
    @State var windowHeight_String = "400"

    var body: some View {
        VStack {
            Form {
                // MARK: - Window

                Group {
                    Text("Window")
                        .font(.system(.title2))
                    Text("The default size of a window. It will take effect on new windows.")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))

                    TextField("Width", text: $windowWidth_String) {
                        if let receivedValue = Float(windowWidth_String) {
                            print(receivedValue)
                            UserPreferences.appearence.width = receivedValue
                        } else {
                            presentAlert_widthCannotConvertToUInt32 = true
                        }
                    }
                    TextField("Height",
                              text: $windowHeight_String) {
                        if let receivedValue = Float(windowHeight_String) {
                            print(receivedValue)
                            UserPreferences.appearence.height = receivedValue
                        } else {
                            presentAlert_heightCannotConvertToUInt32 = true
                        }
                    }
                }

                // MARK: - Color

                Group {
                    Text("Color")
                        .font(.system(.title2))
                    Text("The color of the window. It will take effect on new windows.")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))

                    Picker("Theme", selection: $currentColorTheme) {
                        Text("single")
                            .tag(ColorTheme.single)
                        Text("random")
                            .tag(ColorTheme.random)
                    }
                    .pickerStyle(.inline)
                    .onChange(of: currentColorTheme) { newValue in
                        switch newValue {
                        case .single:
                            UserPreferences.appearence.color_theme = .single
                        case .random:
                            UserPreferences.appearence.color_theme = .random
                        }
                    }

                    // single
                    Group {
                        Picker("Preset", selection: $presetColor) {
                            ForEach(ExStickyColor.allCases) { color in
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
                            UserPreferences.appearence.color = presetColor.rawValue
                        }

                        Toggle("Use customized color", isOn: $isUsingCustomizedColor)

                        TextField("Customization",
                                  text: $customizedColorHex,
                                  onCommit: {
                                      if let value = customizedColorHex.hex2uint32 {
                                          UserPreferences.appearence.color = value
                                      } else {
                                          presentAlert_customColorCannotConvertToUInt32 = true
                                          XCLog(.error, "cannot convert to UInt32")
                                      }
                                  })
                                  .disabled(!isUsingCustomizedColor)
                        Text("input the color hex eg. 0x66CCFF")
                            .foregroundColor(Color.gray)
                            .font(.system(.callout))
                    }
                    .disabled(currentColorTheme == .random)
                }
            }
            .padding()
            .alert(isPresented: $presentAlert_customColorCannotConvertToUInt32) {
                Alert(title: Text("haha"), message: nil, dismissButton: nil)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
