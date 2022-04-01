import Cocoa
import XCLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Application

    func applicationDidFinishLaunching(_: Notification) {
        CreateNewWindow()
        SetupMenu_Window_New()
        SetupMenu_History()
        SetupMenu_Help()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    // MARK: - Windows

    // MARK: TextWindow

    private var window_serial = 0

    private func CreateNewWindow() {
        XCLog(.trace)

        let textWC = TextWC()
        textWC.window!.makeKeyAndOrderFront(self)
        textWC.window!.makeMain()

        window_serial += 1
        let serial: Int = (window_serial - 1) % C.UI_WINDOW_CYCLE

        let x = CGFloat(C.UI_FIRST_WINDOW_X + C.UI_WINDOW_HORIZONTAL_DISTANCE * serial)
        let y = CGFloat(C.UI_FIRST_WINDOW_Y_FROM_TOP_LEFT + C.UI_WINDOW_VERTICLE_DISTANCE * serial)
        textWC.window!.setFrameOrigin(NSPoint(x: x, yFromTop: y, windowHeight: textWC.window!.frame.height))
    }

    // MARK: PreferenceWindow

    private let preferenceWC = PreferenceWC() // instance only once
    private var didOpenPreferenceWindow = false
    @IBAction func Click_Menu_Preferences(_: Any) {
        preferenceWC.window!.makeKeyAndOrderFront(self)
        preferenceWC.window!.makeMain()
        if didOpenPreferenceWindow == false {
            preferenceWC.window!.center() // only center preference window when first open it
            didOpenPreferenceWindow = true
        }
    }

    // MARK: - Menu

    // menu: ExSticky Edit Window History Help

    private func SetupMenu_Window_New() {
        let Menu_Window = NSApp.mainMenu!.item(withTitle: "Window")
        let Menu_Window_New = NSMenuItem(
            title: String(localized: "New"),
            action: #selector(ClickMenu_Window_New(_:)),
            keyEquivalent: "n"
        )
        Menu_Window_New.keyEquivalentModifierMask = .command
        Menu_Window!.submenu!.insertItem(Menu_Window_New, at: 0)
    }

    @objc
    private func ClickMenu_Window_New(_: Any) {
        CreateNewWindow()
    }

    private func SetupMenu_History() {
        // create menu
        let Menu_History = NSMenu(title: C.MENU_TITLE_HISTORY)

        let Menu_History_ClearAll = NSMenuItem(
            title: String(localized: "Clear All"),
            action: #selector(ClickMenu_History_ClearAll(_:)),
            keyEquivalent: ""
        )
        Menu_History.addItem(Menu_History_ClearAll)
        let HistoryMenu_Separator = NSMenuItem.separator()
        Menu_History.addItem(HistoryMenu_Separator)

        // add menu to menu bar
        let mainMenu_History = NSMenuItem(title: C.MENU_TITLE_HISTORY, action: nil, keyEquivalent: "")
        mainMenu_History.submenu = Menu_History
        mainMenu_History.submenu!.autoenablesItems = false // important: if set to true, you cannot set the `isEnable` property on all items
        NSApp.mainMenu!.insertItem(mainMenu_History, at: 3)

        // load history before
        SetupHistoryMenuItems(history: UserData.history)
    }

    @objc
    private func ClickMenu_History_ClearAll(_: NSMenuItem) {
        UserData.history = []
    }

    private func SetupMenu_Help() {
        // create menu
        let Menu_Help = NSMenu(title: C.MENU_TITLE_HELP)

        let Menu_Help_Help = NSMenuItem(
            title: String(localized: "Check Help"),
            action: #selector(ClickMenu_Help_Help(_:)),
            keyEquivalent: "?"
        )
        Menu_Help_Help.keyEquivalentModifierMask = .command
        Menu_Help.addItem(Menu_Help_Help)

        let Menu_Help_Report = NSMenuItem(
            title: String(localized: "Report an Issue"),
            action: #selector(ClickMenu_Help_Report(_:)),
            keyEquivalent: ""
        )
        Menu_Help.addItem(Menu_Help_Report)

        // add menu to menu bar
        let mainMenu_Help = NSMenuItem(title: C.MENU_TITLE_HELP, action: nil, keyEquivalent: "")
        mainMenu_Help.submenu = Menu_Help
        NSApp.mainMenu!.insertItem(mainMenu_Help, at: 4)
    }

    @objc
    private func ClickMenu_Help_Help(_: NSMenuItem) {
        let url = URL(string: "https://ex-studio.github.io/ExSticky-Site/help/")!
        NSWorkspace.shared.open(url)
    }

    @objc
    private func ClickMenu_Help_Report(_: NSMenuItem) {
        let url = URL(string: "https://ex-studio.github.io/ExSticky-Site/report/")!
        NSWorkspace.shared.open(url)
    }
}
