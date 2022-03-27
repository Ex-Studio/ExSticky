import Cocoa

extension NSColor {
    convenience init(hexred: UInt8, green: UInt8, blue: UInt8, alpha: Float) {
        let r = CGFloat(Float(hexred) / 256)
        let g = CGFloat(Float(green) / 256)
        let b = CGFloat(Float(blue) / 256)

        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}

extension NSColor {
    convenience init(hex: UInt32, alpha: Float) {
        let r = CGFloat(Float(hex >> 16) / 256)
        let g = CGFloat(Float((hex << 16) >> 24) / 256)
        let b = CGFloat(Float((hex << 24) >> 24) / 256)

        self.init(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
}
