import AppKit
import Foundation

extension NSPoint {
    init(x: CGFloat, yFromTopLeft: CGFloat, windowHeight: CGFloat) {
        let screenHeight = NSScreen.main!.frame.height
        self.init(x: x, y: screenHeight - yFromTopLeft - windowHeight)
    }
}
