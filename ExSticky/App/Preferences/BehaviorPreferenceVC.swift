import Cocoa
import SwiftUI

class BehaviorPreferenceVC: NSHostingController<BehaviorPreferenceView> {
    convenience init() {
        self.init(rootView: BehaviorPreferenceView())
    }
}

struct BehaviorPreferenceView: View {
    @State var float: Bool = UserSettings.behavior.float
    @State var appearOnAllDesktop: Bool = UserSettings.behavior.appearOnAllDesktop

    var body: some View {
        VStack {
            Form {
                Text(String(localized: "Window Behavior"))
                    .font(.system(.title))

                Group {
                    Toggle(String(localized: "Floating"), isOn: $float)
                        .onChange(of: float) { _ in
                            UserSettings.behavior.float = float
                        }

                    Text(String(localized: "Should windows float on the top."))
                        .foregroundColor(Color.gray)
                        .font(.system(.callout))
                }

                Group {
                    Toggle(String(localized: "Appear on All Desktops"),
                           isOn: $appearOnAllDesktop)
                        .onChange(of: appearOnAllDesktop) { _ in
                            UserSettings.behavior.appearOnAllDesktop = appearOnAllDesktop
                        }

                    Text(String(localized: "Should windows appear on all desktops."))
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
    }
}
