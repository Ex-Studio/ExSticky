import Cocoa

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

    var localizedName: String {
        switch self {
        case .red: return String(localized: "Red")
        case .orange: return String(localized: "Orange")
        case .yellow: return String(localized: "Yellow")
        case .green: return String(localized: "Green")
        case .blue: return String(localized: "Blue")
        }
    }
}

enum ExStickySelectionTextColor: String, CaseIterable, Identifiable {
    case automatic
    case white
    case black

    var id: String { rawValue }

    var localizedName: String {
        switch self {
        case .automatic: return String(localized: "Automatic pairing")
        case .white: return String(localized: "White")
        case .black: return String(localized: "Black")
        }
    }
}

struct ExStickySelectionPalette {
    let background: NSColor
    let foreground: NSColor

    init(noteColor: NSColor, mode: ExStickySelectionTextColor) {
        let color = noteColor.usingColorSpace(.sRGB) ?? NSColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        let hue = color.hueComponent
        let saturation = color.saturationComponent
        let dark = Self.color(hue: hue, saturation: saturation * 0.60, luminance: 0.045)
        let light = Self.color(hue: hue, saturation: saturation * 0.15, luminance: 0.82)

        let useDark: Bool
        switch mode {
        case .automatic:
            // A practical bias for light desktops, not detection of the desktop color.
            useDark = color.alphaComponent < 0.6 || Self.contrast(dark, color) >= Self.contrast(light, color)
        case .white:
            useDark = true
        case .black:
            useDark = false
        }
        background = useDark ? dark : light
        switch mode {
        case .white: foreground = .white
        case .black: foreground = .black
        case .automatic:
            foreground = Self.srgbColor(hue: hue,
                                       saturation: saturation * (useDark ? 0.035 : 0.30),
                                       brightness: useDark ? 0.99 : 0.16)
        }
    }

    private static func srgbColor(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> NSColor {
        NSColor(colorSpace: .sRGB, hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }

    private static func color(hue: CGFloat, saturation: CGFloat, luminance target: CGFloat) -> NSColor {
        let brightest = srgbColor(hue: hue, saturation: saturation, brightness: 1)
        guard luminance(brightest) > target else { return brightest }
        var lower: CGFloat = 0
        var upper: CGFloat = 1
        for _ in 0..<18 {
            let midpoint = (lower + upper) / 2
            if luminance(srgbColor(hue: hue, saturation: saturation, brightness: midpoint)) < target {
                lower = midpoint
            } else {
                upper = midpoint
            }
        }
        let lowColor = srgbColor(hue: hue, saturation: saturation, brightness: lower)
        let highColor = srgbColor(hue: hue, saturation: saturation, brightness: upper)
        return abs(luminance(lowColor) - target) < abs(luminance(highColor) - target) ? lowColor : highColor
    }

    private static func luminance(_ color: NSColor) -> CGFloat {
        func linear(_ component: CGFloat) -> CGFloat {
            component <= 0.04045 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linear(color.redComponent)
            + 0.7152 * linear(color.greenComponent)
            + 0.0722 * linear(color.blueComponent)
    }

    private static func contrast(_ first: NSColor, _ second: NSColor) -> CGFloat {
        let y1 = luminance(first)
        let y2 = luminance(second)
        return (max(y1, y2) + 0.05) / (min(y1, y2) + 0.05)
    }
}
