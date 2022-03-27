import Cocoa

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

    var windowQueue: [NSWindow] = [] // 这里只是存了指针 会多存储指针 但是问题不大 至于为什么要放到外面是因为放到函数体里面创建后关闭可能会造成重复释放 // 在窗口关闭之后 内存会清空的 但是如果将该数组内的指针清空 由于ARC 会引起二次释放 程序崩溃 简单来说现在这么用没什么问题 也不会有内存泄漏（最多泄漏十几个指针的空间） 每次应用退出都会归零的

    private func CreateNewWindow() {
        windowQueue.append(MainWindow())
        windowQueue.last?.makeKeyAndOrderFront(self)
        windowQueue.last?.center()
    }

    @IBAction func closeCurrentWindow(_: Any) {
        print("closeCurrentWindow")
    }

    @IBAction func createNewWindow(_: Any) {
        print("createNewWindow")
        CreateNewWindow()
    }
}
