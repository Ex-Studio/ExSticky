import Cocoa
import SwiftUI
import XCLog

class BehaviorPreferenceVC: NSHostingController<BehaviorPreferenceView> {
    convenience init() {
        self.init(rootView: BehaviorPreferenceView())
    }
}

struct BehaviorPreferenceView: View {
    @State var float:Bool = UserPreferences.behavior.float
    @State var appearOnAllDesktop:Bool = UserPreferences.behavior.appearOnAllDesktop

    var body: some View {
        Form {
            Text("Window Behavior")
                .font(.system(.title))
            
            Group {
                Toggle("Floating", isOn: $float)
                    .onChange(of: float) { _ in
                        UserPreferences.behavior.float = float
                    }

                Text("Should windows float on the top.\nChanges will take effect on new windows.")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))
            }
            
            Group {
                Toggle("Appear on All Desktops", isOn: $appearOnAllDesktop)
                    .onChange(of: appearOnAllDesktop) { _ in
                        UserPreferences.behavior.appearOnAllDesktop = appearOnAllDesktop
                    }

                Text("Should windows appear on all desktops.\nChanges will take effect on new windows.")
                    .foregroundColor(Color.gray)
                    .font(.system(.callout))
            }
        }
        .padding()
    }
}

