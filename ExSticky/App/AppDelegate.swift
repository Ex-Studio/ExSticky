import Cocoa
import XCLog

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Application

    func applicationDidFinishLaunching(_: Notification) {
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

        let window_serial: Int = (textWindowQueue.count - 1) % 8
        let x = CGFloat(10 + 20 * window_serial)
        let y = CGFloat(10 + 26 * window_serial)
        textWindowQueue.last!.setFrameOrigin(NSPoint(x: x, yFromTopLeft: y, windowHeight: textWindowQueue.last!.frame.height))
    }

    @IBAction func MenuNew(_: Any) {
        XCLog(.trace)
        CreateNewWindow()
    }

    // MARK: PreferenceWindow

    private let preferenceWC = PreferenceWC() // instance only once
    private var didOpenPreferenceWindow = false
    @IBAction func MenuPreference(_: Any) {
        XCLog(.trace)
        preferenceWC.window!.makeKeyAndOrderFront(self)
        if didOpenPreferenceWindow == false {
            preferenceWC.window!.center() // only center preference window when first open it
            didOpenPreferenceWindow = true
        }
    }
}
