import Cocoa

class PreferenceWC: NSWindowController {
    private var preferenceVC: NSTabViewController!
    private var textTab: NSTabViewItem!
    private var appearanceTab: NSTabViewItem!
    private var behaviorTab: NSTabViewItem!

    convenience init() {
        let window: NSWindow = {
            let w = NSWindow(
                contentRect: .zero,
                styleMask: [.titled, .closable],
                backing: .buffered,
                defer: true
            )
            w.title = String(localized: "Preferences")
            w.toolbarStyle = .preference
            return w
        }()
        self.init(window: window)

        preferenceVC = NSTabViewController()
        preferenceVC.tabStyle = .toolbar

        textTab = NSTabViewItem(viewController: TextPreferenceVC())
        textTab.label = String(localized: "Text")
        textTab.image = NSImage(systemSymbolName: "textformat.alt", accessibilityDescription: "")
        appearanceTab = NSTabViewItem(viewController: AppearancePreferenceVC())
        appearanceTab.label = String(localized: "Appearance")
        appearanceTab.image = NSImage(systemSymbolName: "macwindow", accessibilityDescription: "")
        behaviorTab = NSTabViewItem(viewController: BehaviorPreferenceVC())
        behaviorTab.label = String(localized: "Behavior")
        behaviorTab.image = NSImage(systemSymbolName: "rectangle.3.group", accessibilityDescription: "")
        preferenceVC.addTabViewItem(textTab)
        preferenceVC.addTabViewItem(appearanceTab)
        preferenceVC.addTabViewItem(behaviorTab)

        contentViewController = preferenceVC
    }
}
