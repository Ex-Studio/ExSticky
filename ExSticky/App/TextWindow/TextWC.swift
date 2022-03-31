import Cocoa
import XCLog

class TextWC: NSWindowController {
    convenience init() {
        self.init(window: TextWindow())
    }
}
