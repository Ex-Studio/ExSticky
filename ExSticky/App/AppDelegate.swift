import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: - Application

    func applicationDidFinishLaunching(_: Notification) {
        CreateAndShowMainWindow()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_: NSApplication) -> Bool {
        true
    }

    // MARK: - Windows

    /// main window
    private let mainWindow = MainWindow()
    private func CreateAndShowMainWindow() {
        mainWindow.makeKeyAndOrderFront(self) // shows the window
        mainWindow.center()
    }
}
