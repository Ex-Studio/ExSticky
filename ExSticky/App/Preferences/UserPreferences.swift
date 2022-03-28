import AppKit
import Foundation
import XCLog

// TODO: 每一个identifier都做成一个变量

struct ExStickyPreferences {
    static var shared = ExStickyPreferences()

    var text = Text()
    var appearence = Appearence()
    var behavior = Behavior()

    // MARK: - Text

    struct Text {
        let defautlt_size: Float = 24.0
        let defautlt_font = "SF Mono"
        let key_size = "exsticky.text.size"
        let key_font = "exsticky.text.font"

        var size: Float {
            set {
                UserDefaults.standard.set(newValue, forKey: key_size)
            }
            get {
                let size = UserDefaults.standard.float(forKey: key_size)
                if size != 0.0 {
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

var UserPreferences = ExStickyPreferences.shared
