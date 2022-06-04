import Cocoa
import XCLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Application

    func applicationDidFinishLaunching(_: Notification) {
        SetupMenu_Window_Opacity()
        SetupMenu_Window_New()
        SetupMenu_History()
        SetupMenu_Help()
        CreateNewWindow()
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

    // MARK: Window > New

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

    // MARK: Window > Opacity

    private func SetupMenu_Window_Opacity() {
        let Menu_Window = NSApp.mainMenu!.item(withTitle: C.MENU_TITLE_WINDOW)

        let Menu_Window_Opacity_1 = NSMenuItem(
            title: String(localized: "0.1"),
            action: #selector(ClickMenu_Window_Opacity_1(_:)),
            keyEquivalent: "1"
        )
        Menu_Window_Opacity_1.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_2 = NSMenuItem(
            title: String(localized: "0.2"),
            action: #selector(ClickMenu_Window_Opacity_2(_:)),
            keyEquivalent: "2"
        )
        Menu_Window_Opacity_2.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_3 = NSMenuItem(
            title: String(localized: "0.3"),
            action: #selector(ClickMenu_Window_Opacity_3(_:)),
            keyEquivalent: "3"
        )
        Menu_Window_Opacity_3.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_4 = NSMenuItem(
            title: String(localized: "0.4"),
            action: #selector(ClickMenu_Window_Opacity_4(_:)),
            keyEquivalent: "4"
        )
        Menu_Window_Opacity_4.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_5 = NSMenuItem(
            title: String(localized: "0.5"),
            action: #selector(ClickMenu_Window_Opacity_5(_:)),
            keyEquivalent: "5"
        )
        Menu_Window_Opacity_5.keyEquivalentModifierMask = .command
        let Menu_Window_Opacity_6 = NSMenuItem(
            title: String(localized: "0.6"),
            action: #selector(ClickMenu_Window_Opacity_6(_:)),
            keyEquivalent: "6"
        )
        Menu_Window_Opacity_6.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_7 = NSMenuItem(
            title: String(localized: "0.7"),
            action: #selector(ClickMenu_Window_Opacity_7(_:)),
            keyEquivalent: "7"
        )
        Menu_Window_Opacity_7.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_8 = NSMenuItem(
            title: String(localized: "0.8"),
            action: #selector(ClickMenu_Window_Opacity_8(_:)),
            keyEquivalent: "8"
        )
        Menu_Window_Opacity_8.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_9 = NSMenuItem(
            title: String(localized: "0.9"),
            action: #selector(ClickMenu_Window_Opacity_9(_:)),
            keyEquivalent: "9"
        )
        Menu_Window_Opacity_9.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity_0 = NSMenuItem(
            title: String(localized: "1.0"),
            action: #selector(ClickMenu_Window_Opacity_0(_:)),
            keyEquivalent: "0"
        )
        Menu_Window_Opacity_0.keyEquivalentModifierMask = .command

        let Menu_Window_Opacity = NSMenuItem(title: C.MENU_TITLE_WINDOW_OPACITY, action: nil, keyEquivalent: "")
        let Menu_Window_Opacity_Submenu = NSMenu()
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_0, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_9, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_8, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_7, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_6, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_5, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_4, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_3, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_2, at: 0)
        Menu_Window_Opacity_Submenu.insertItem(Menu_Window_Opacity_1, at: 0)
        Menu_Window_Opacity.submenu = Menu_Window_Opacity_Submenu

        Menu_Window!.submenu!.insertItem(Menu_Window_Opacity, at: 0)
    }

    @objc
    private func ClickMenu_Window_Opacity_1(_: Any) {
        SetKeyWindowOpacity(0.1)
    }

    @objc
    private func ClickMenu_Window_Opacity_2(_: Any) {
        SetKeyWindowOpacity(0.2)
    }

    @objc
    private func ClickMenu_Window_Opacity_3(_: Any) {
        SetKeyWindowOpacity(0.3)
    }

    @objc
    private func ClickMenu_Window_Opacity_4(_: Any) {
        SetKeyWindowOpacity(0.4)
    }

    @objc
    private func ClickMenu_Window_Opacity_5(_: Any) {
        SetKeyWindowOpacity(0.5)
    }

    @objc
    private func ClickMenu_Window_Opacity_6(_: Any) {
        SetKeyWindowOpacity(0.6)
    }

    @objc
    private func ClickMenu_Window_Opacity_7(_: Any) {
        SetKeyWindowOpacity(0.7)
    }

    @objc
    private func ClickMenu_Window_Opacity_8(_: Any) {
        SetKeyWindowOpacity(0.8)
    }

    @objc
    private func ClickMenu_Window_Opacity_9(_: Any) {
        SetKeyWindowOpacity(0.9)
    }

    @objc
    private func ClickMenu_Window_Opacity_0(_: Any) {
        SetKeyWindowOpacity(1.0)
    }

    private func SetKeyWindowOpacity(_ opacity: Float) {
        if opacity > 1.0 || opacity < 0.0 {
            XCLog(.error, "uncorrect opacity")
            return
        }
        guard let current_window = NSApp.keyWindow else { return }
        guard let previous_color = current_window.backgroundColor else { return }
        current_window.backgroundColor = NSColor(red: previous_color.redComponent,
                                                 green: previous_color.greenComponent,
                                                 blue: previous_color.blueComponent,
                                                 alpha: CGFloat(opacity))
    }

    // MARK: History

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

    // MARK: Help

    private func SetupMenu_Help() {
        // create menu
        let Menu_Help = NSMenu(title: C.MENU_TITLE_HELP)

        // Help
        let Menu_Help_Help = NSMenuItem(
            title: String(localized: "Check Help"),
            action: #selector(ClickMenu_Help_Help(_:)),
            keyEquivalent: "?"
        )
        Menu_Help_Help.keyEquivalentModifierMask = .command
        Menu_Help.addItem(Menu_Help_Help)

        // Report
        let Menu_Help_Report = NSMenuItem(
            title: String(localized: "Report an Issue"),
            action: #selector(ClickMenu_Help_Report(_:)),
            keyEquivalent: ""
        )
        Menu_Help.addItem(Menu_Help_Report)

        // Support
        let Menu_Help_Support = NSMenuItem(
            title: String(localized: "Support"),
            action: #selector(ClickMenu_Help_Support(_:)),
            keyEquivalent: ""
        )
        Menu_Help.addItem(Menu_Help_Support)

        // Open Source
        let Menu_Help_OpenSource = NSMenuItem(
            title: String(localized: "GitHub Repository"),
            action: #selector(ClickMenu_Help_OpenSource(_:)),
            keyEquivalent: ""
        )
        Menu_Help.addItem(Menu_Help_OpenSource)

        // add menu to menu bar
        let mainMenu_Help = NSMenuItem(title: C.MENU_TITLE_HELP, action: nil, keyEquivalent: "")
        mainMenu_Help.submenu = Menu_Help
        NSApp.mainMenu!.insertItem(mainMenu_Help, at: 4)
    }

    @objc
    private func ClickMenu_Help_Help(_: NSMenuItem) {
        let url = URL(string: "https://ex-studio.github.io/ExSticky/help")!
        NSWorkspace.shared.open(url)
    }

    @objc
    private func ClickMenu_Help_Report(_: NSMenuItem) {
        let url = URL(string: "https://ex-studio.github.io/ExSticky/report/")!
        NSWorkspace.shared.open(url)
    }

    @objc
    private func ClickMenu_Help_OpenSource(_: NSMenuItem) {
        let url = URL(string: "https://ex-studio.github.io/ExSticky/open-source/")!
        NSWorkspace.shared.open(url)
    }

    @objc
    private func ClickMenu_Help_Support(_: NSMenuItem) {
        UserData.did_open_support = true
        let url = URL(string: "https://ex-studio.github.io/ExSticky/support/")!
        NSWorkspace.shared.open(url)
    }
}
