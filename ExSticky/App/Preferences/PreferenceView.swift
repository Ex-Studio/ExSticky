import Cocoa
import SwiftUI

struct PreferenceView: View {
    @State var isOn = true
    var body: some View {
        TabView {
            Text("The First Tab")
                .tabItem { Text("Text") }
            Text("Another Tab")
                .tabItem { Text("Appearance") }
            Text("The Last Tab")
                .tabItem { Text("Behavior") }
        }
        .tabViewStyle(.automatic)
        .padding()
        .font(.headline)
    }
}
