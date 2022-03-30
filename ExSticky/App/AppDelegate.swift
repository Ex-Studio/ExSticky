import Cocoa
import XCLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Application

    func applicationDidFinishLaunching(_: Notification) {
        CreateNewWindow()
        SetupHistoryMenu()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    /// menu: ExSticky Edit Window History Help
    private func SetupHistoryMenu() {
        // create menu
        let HistoryMenu = NSMenu(title: C.MENU_TITLE_HISTORY)

        let HistoryMenu_ClearAll = NSMenuItem(
            title: String(localized: "Clear All"),
            action: #selector(Click_Menu_History_ClearAll(_:)),
            keyEquivalent: ""
        )
        HistoryMenu.addItem(HistoryMenu_ClearAll)
        let HistoryMenu_Separator = NSMenuItem.separator()
        HistoryMenu.addItem(HistoryMenu_Separator)

        // add menu to menu bar
        let main_HistoryMenu = NSMenuItem(title: C.MENU_TITLE_HISTORY, action: nil, keyEquivalent: "")
        main_HistoryMenu.submenu = HistoryMenu
        main_HistoryMenu.submenu!.autoenablesItems = false // important: if set to true, you cannot set the `isEnable` property on all items
        NSApp.mainMenu!.insertItem(main_HistoryMenu, at: 3)

        // load history before
        SetupHistoryMenuItems(history: UserData.history)
    }

    @objc
    private func Click_Menu_History_ClearAll(_: NSMenuItem) {
        UserData.history = []
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
        textWindowQueue.last!.setFrameOrigin(NSPoint(x: x, yFromTopLeft: y, windowHeight: textWindowQueue.last!.frame.height))
    }

    @IBAction func Click_Menu_Window_New(_: Any) {
        CreateNewWindow()
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
    
    // MARK: HelpWindow
    
    private let helpWC = HelpWC() // instance only once
    private var didOpenHelpWindow = false
    @IBAction func Click_Menu_Help(_: Any) {
        helpWC.window!.makeKeyAndOrderFront(self)
        if didOpenHelpWindow == false {
            helpWC.window!.center() // only center preference window when first open it
            didOpenHelpWindow = true
        }
    }
}
