import Cocoa
import XCLog

class TextWindowDelegate: NSObject, NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        guard let window = notification.object as? TextWindow else { return }
        XCLog(.debug, "\(window.view!.textView.selectedRanges)")
        window.view!.textView.setSelectedRange(NSRange(
            location: window.view!.textView.selectedRanges.first!.rangeValue.location, // save position of cursor
            length: 0 // remove selection
        ))
    }
}
