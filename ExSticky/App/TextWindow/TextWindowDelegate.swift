import Cocoa
import XCLog

class TextWindowDelegate: NSObject, NSWindowDelegate {
    // MARK: - solved: window resigns key and the selection becomes not transparent (only consider single selection)

    private var previous_selection = NSRange(location: 0, length: 0)

    func windowDidResignKey(_ notification: Notification) {
        guard let window = notification.object as? TextWindow else { return }
//        XCLog(.debug, "\(window.view!.textView.selectedRanges)")
        self.previous_selection = window.view!.textView.selectedRanges.first!.rangeValue
        // remove selection
        window.view!.textView.setSelectedRange(NSRange(location: 0, length: 0))
    }

    func windowDidBecomeKey(_ notification: Notification) {
        guard let window = notification.object as? TextWindow else { return }
        window.view!.textView.setSelectedRange(previous_selection)
    }
}
