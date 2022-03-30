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

    private var textWindowQueue: [TextWindow] = [] // 这里只是存了指针 会多存储指针 但是问题不大 至于为什么要放到外面是因为放到函数体里面创建后关闭可能会造成重复释放 // 在窗口关闭之后 内存会清空的 但是如果将该数组内的指针清空 由于ARC 会引起二次释放 程序崩溃 简单来说现在这么用没什么问题 也不会有内存泄漏（最多泄漏十几个指针的空间） 每次应用退出都会归零的 // FIXME: 用WindowController会不会更好一些

    private func CreateNewWindow() {
        textWindowQueue.append(TextWindow())
        textWindowQueue.last!.makeKeyAndOrderFront(self)

        let window_serial: Int = (textWindowQueue.count - 1) % C.UI_WINDOW_CYCLE
        let x = CGFloat(C.UI_FIRST_WINDOW_X + C.UI_WINDOW_HORIZONTAL_DISTANCE * window_serial)
        let y = CGFloat(C.UI_FIRST_WINDOW_Y_FROM_TOP_LEFT + C.UI_WINDOW_VERTICLE_DISTANCE * window_serial)
        textWindowQueue.last!.setFrameOrigin(NSPoint(x: x, yFromTop: y, windowHeight: textWindowQueue.last!.frame.height))
    }

    // MARK: PreferenceWindow

    private let preferenceWC = PreferenceWC() // instance only once
    private var didOpenPreferenceWindow = false
    @IBAction func Click_Menu_Preferences(_: Any) {
        preferenceWC.window!.makeKeyAndOrderFront(self)
        if didOpenPreferenceWindow == false {
            preferenceWC.window!.center() // only center preference window when first open it
            didOpenPreferenceWindow = true
        }
    }

    // MARK: - Menu

    // menu: ExSticky Edit Window History Help
    
    private func SetupMenu_Window_New(){
        
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
