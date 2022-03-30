import Cocoa
import SwiftUI
import XCLog

class HelpVC: NSHostingController<HelpView> {
    convenience init() {
        self.init(rootView: HelpView())
    }
}

struct HelpView: View {
    var body: some View {
        Text(C.HELP_INFO)
            .padding()
            .frame(width: 400,
                   height: 400 / sqrt(2),
                   alignment: .center)
    }
}
