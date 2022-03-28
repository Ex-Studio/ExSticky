import AppKit
import Foundation
import XCLog

var UserPreferences = ExStickyPreferences.shared

struct ExStickyPreferences {
    static var shared = ExStickyPreferences()

    var text = Text()
    var appearence = Appearence()
    var behavior = Behavior()

    // MARK: - Text

    struct Text {
        let max_size = 72
        let min_size = 12
        let defautlt_size = 24
        let defautlt_font = "SFMono-Regular"
        let key_size = "exsticky.text.size"
        let key_font = "exsticky.text.font"

        var size: Int {
            set {
                UserDefaults.standard.set(newValue, forKey: key_size)
            }
            get {
                let size = UserDefaults.standard.integer(forKey: key_size)
                if size != 0 {
                    return size
                } else { // this key not exist
                    UserDefaults.standard.set(defautlt_size, forKey: key_size)
                    return defautlt_size
                }
            }
        }

        var font: String {
            set {
                if NSFontManager.shared.availableFonts.contains(newValue) {
                    UserDefaults.standard.set(newValue, forKey: key_font)
                } else {
                    UserDefaults.standard.set(defautlt_font, forKey: key_font)
                    XCLog(.error, "no such font in the user's system")
                }
            }
            get {
                if let f = UserDefaults.standard.string(forKey: key_font) {
                    if NSFontManager.shared.availableFonts.contains(f) {
                        return f
                    } else {
                        return defautlt_font
                    }

                } else { // this key not exist
                    UserDefaults.standard.set(defautlt_size, forKey: key_font)
                    return defautlt_font
                }
            }
        }
    }

    struct Appearence {
        let defautlt_size = 24
        let defautlt_font = "SFMono-Regular"
        let key_color_theme = "exsticky.appearance.color_theme"

        var color_theme: ColorTheme {
            get {
                if let value = UserDefaults.standard.string(forKey: key_color_theme) {
                    if value == "single" {
                        return .single
                    } else if value == "random" {
                        return .random
                    } else {
                        XCLog(.error)
                        return .single
                    }
                } else {
                    UserDefaults.standard.set("single", forKey: key_color_theme)
                    return .single
                }
            }

            set {
                switch newValue {
                case .single:
                    UserDefaults.standard.set("single", forKey: key_color_theme)
                case .random:
                    UserDefaults.standard.set("random", forKey: key_color_theme)
                }
            }
        }

        var alpha: Float = 0.2
        var color: UInt32 = 0x66CCFF // TODO: add get set
        var width: Float = 400 * sqrt(2)
        var height: Float = 400
    }

    struct Behavior {
        var float = true
        var appearInAllDesktop = true
    }
}

enum ColorTheme: String, Identifiable, CaseIterable {
    case single
    case random

    var id: String { self.rawValue }
}
