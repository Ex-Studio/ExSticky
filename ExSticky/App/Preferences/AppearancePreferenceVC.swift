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

    @State var presetColor: ExStickyColor = .systemBlue

    @State var isUsingCustomizedColor = false

    @State var customizedColorHex = "0x66CCFF"

    var body: some View {
        VStack {
            Form {
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
                Group {
                    Picker("Preset", selection: $presetColor) {
                        ForEach(ExStickyColor.allCases) { color in
                            Text("\(color.rawValue)")
                                .tag(color)
                        }
                    }
                    .disabled(currentColorTheme == .random || isUsingCustomizedColor)

                    Toggle("Use customized color", isOn: $isUsingCustomizedColor)
                        .disabled(currentColorTheme == .random)

                    TextField("Customization",
                              text: $customizedColorHex,
                              onCommit: {
                                  print("haha")
                              })
                              .disabled(!isUsingCustomizedColor)
                    Text("input the color hex eg. 0x66CCFF")
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }
            }
            .padding()
        }
    }
}

enum ExStickyColor: String, Identifiable, CaseIterable {
    case systemBlue
    case systemGreen
    case systemRed

    var id: String { self.rawValue }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
