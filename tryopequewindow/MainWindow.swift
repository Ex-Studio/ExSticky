// MainWindow.swift

import Cocoa

class MainWindow: NSWindow {
    // MARK: - Window

    convenience init() {
        let styleMask: NSWindow.StyleMask = [.titled, .closable, .miniaturizable, .resizable]
        self.init(
            /// set it after initializing
            contentRect: .zero,
            /// You cannot use `[]` here and use `self.styleMask = [.titled, ...]` after it, which may cause effects losing, though in documentation `NSWindow.styleMask`, Apple says that "setting this property has the same restrictions as the styleMask parameter of `init(contentRect:styleMask:backing:defer:)`".
            styleMask: styleMask,
            /// only `.buffered` is supported
            backing: .buffered,
            /// "Deferring the creation of the window improves launch time and minimizes the virtual memory load on the window server."
            defer: true
        )

        ConfigureWindow()

        AddMainView()
    }

    private func ConfigureWindow() {
        self.title = "Main Window"
        self.setContentSize(.init(width: 300, height: 400))
    }

    // MARK: - Views

    /// main view
    let mainView = MainView()
    private func AddMainView() {
        self.contentView = mainView // 这里设置contentView应该会改变mainView的属性，比如mainView的frame变成了窗口的contentSize
    }
}
