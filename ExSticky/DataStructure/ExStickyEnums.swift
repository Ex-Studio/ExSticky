import Foundation

enum ExStickyColorTheme: String, Identifiable, CaseIterable {
    case single
    case random

    var id: String { self.rawValue }
}

enum ExStickyPresetColor: UInt32, Identifiable, CaseIterable {
    case red = 0xFF3B30
    case orange = 0xFF9500
    case yellow = 0xFFCC00
    case green = 0x28CD41
    case blue = 0x007AFF

    var id: UInt32 { self.rawValue }
}
