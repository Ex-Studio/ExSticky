import Cocoa
import XCLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Application

    func applicationDidFinishLaunching(_: Notification) {
        AppStartTest()

        CreateNewWindow()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    // MARK: - Windows

    // MARK: TextWindow

    private var textWindowQueue: [TextWindow] = [] // 这里只是存了指针 会多存储指针 但是问题不大 至于为什么要放到外面是因为放到函数体里面创建后关闭可能会造成重复释放 // 在窗口关闭之后 内存会清空的 但是如果将该数组内的指针清空 由于ARC 会引起二次释放 程序崩溃 简单来说现在这么用没什么问题 也不会有内存泄漏（最多泄漏十几个指针的空间） 每次应用退出都会归零的

    private func CreateNewWindow() {
        textWindowQueue.append(TextWindow())
        textWindowQueue.last!.makeKeyAndOrderFront(self)
        if textWindowQueue.count < 16 {
            let screenh = NSScreen.main!.frame.size.height
            textWindowQueue.last!.setFrameOrigin(
                NSPoint(x: CGFloat(10 + 20 * (textWindowQueue.count - 1)),
                        y: screenh - CGFloat(10) - textWindowQueue.last!.frame.height - CGFloat(26 * (textWindowQueue.count - 1))))
        } else {
            textWindowQueue.last?.center()
        }
    }

    @IBAction func MenuNew(_: Any) {
        XCLog(.trace)
        CreateNewWindow()
    }

    // MARK: PreferenceWindow

    private let preferenceWC = PreferenceWC()
    private var hasOpenedPreferences = false
    @IBAction func MenuPreference(_: Any) {
        XCLog(.trace)
        preferenceWC.window!.makeKeyAndOrderFront(self)
        if hasOpenedPreferences == false {
            preferenceWC.window!.center()
            hasOpenedPreferences = true
        }
    }
}

func AppStartTest() {
    XCLog(.debug, "\(NSFontManager.shared.availableFonts)", false)
}
