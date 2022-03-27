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
                contentRect: .init(x: 0, y: 0, width: 100, height: 100),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: true
            )
            w.title = "haha"
            w.toolbarStyle = .preference

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
