import Cocoa

class TextWindowDelegate: NSObject, NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        guard let window = notification.object as? TextWindow else { return }
        window.view.updateSelectionAppearance(isActive: false)
    }

    func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? TextWindow else { return }
        window.view.updateSelectionAppearance(isActive: true)
    }
}
