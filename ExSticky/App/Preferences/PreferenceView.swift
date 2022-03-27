import Cocoa
import SwiftUI
import XCLog

struct PreferenceView: View {
    var body: some View {
        TabView {
            TextPreferenceTab()
                .tabItem { Text("Text") }
            AppearancePreferenceTab()
                .tabItem { Text("Appearance") }
            BehaviorPreferenceTab()
                .tabItem { Text("Behavior") }
        }
        .padding()
    }
}

struct TextPreferenceTab: View {
    @State var size: Float = 0.0
    var body: some View {
        VStack {
            HStack {
                Text("Text Size")
                Slider(value: $size, in: 10.0 ... 72.0)
                    .onChange(of: size) { newValue in
                        XCLog(.debug, "\(newValue)")
                        // TODO
                    }
            }
        }
    }
}

struct AppearancePreferenceTab: View {
    var body: some View {
        Text("The First Tab")
    }
}

struct BehaviorPreferenceTab: View {
    @State var isOn = true

    var body: some View {
        Text("The First Tab")
    }
}
