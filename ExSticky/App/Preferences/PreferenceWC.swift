import Cocoa
import XCLog

class PreferenceWC: NSWindowController {
    private var tabVC: NSTabViewController!
    private var textItem: NSTabViewItem!
    private var appearanceItem: NSTabViewItem!
    private var behaviorItem: NSTabViewItem!

    convenience init() {
        let window: NSWindow = {
            let w = NSWindow(
                contentRect: .zero,
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: true
            )
            w.title = "Preferences"
            w.toolbarStyle = .preference
            w.maxSize = NSSize(width: 400, height: 400 / sqrt(2))
            w.minSize = NSSize(width: 400, height: 400 / sqrt(2))

            return w

        }()
        self.init(window: window)

        tabVC = NSTabViewController()
        tabVC.tabStyle = .toolbar

        textItem = NSTabViewItem(viewController: TextPreferenceVC())
        textItem.label = "Text"
        textItem.image = NSImage(systemSymbolName: "textformat.alt", accessibilityDescription: "")
        appearanceItem = NSTabViewItem(viewController: AppearancePreferenceVC())
        appearanceItem.label = "Appearance"
        appearanceItem.image = NSImage(systemSymbolName: "macwindow", accessibilityDescription: "")
        behaviorItem = NSTabViewItem(viewController: BehaviorPreferenceVC())
        behaviorItem.label = "Behavior"
        behaviorItem.image = NSImage(systemSymbolName: "rectangle.3.group", accessibilityDescription: "")
        tabVC.addTabViewItem(textItem)
        tabVC.addTabViewItem(appearanceItem)
        tabVC.addTabViewItem(behaviorItem)

        contentViewController = tabVC
    }
}
