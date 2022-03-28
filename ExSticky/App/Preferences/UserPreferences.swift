import AppKit
import Foundation
import XCLog

// TODO: random color

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
        private let key_size = "exsticky.text.size"
        private let key_font = "exsticky.text.font"

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
        
        // MARK: theme
        
        private let key_color_theme = "exsticky.appearance.color_theme"
        var color_theme: ColorTheme {
            get {
                if let value = UserDefaults.standard.string(forKey: key_color_theme) {
                    if value == ColorTheme.single.rawValue {
                        return .single
                    } else if value == ColorTheme.random.rawValue {
                        return .random
                    } else { // error
                        XCLog(.error)
                        return .single
                    }
                } else { // default value
                    UserDefaults.standard.set("single", forKey: key_color_theme)
                    return .single
                }
            }
            set {
                UserDefaults.standard.set(newValue.rawValue, forKey: key_color_theme)
            }
        }

        private let key_openCustomizedColor = "exsticky.appearance.openCustomizedColor"
        var openCustomizedColor: Bool {
            get {
                return UserDefaults.standard.bool(forKey: key_openCustomizedColor) // default false
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_openCustomizedColor)
            }
        }

        
        // 新建窗口的颜色
        private let key_color = "exsticky.appearance.color"
        private let default_color = PresetColor.blue.rawValue
        var color: UInt32 {
            get {
                if UserDefaults.standard.integer(forKey: key_color) == 0 {
                    return default_color
                } else {
                    return UInt32(UserDefaults.standard.integer(forKey: key_color))
                }
            }
            set {
                let value = UInt32(newValue)
                UserDefaults.standard.set(value, forKey: key_color)
            }
        }

        // 用户自定义的那个颜色 希望下次开启app还保留
        private let key_customizedColor = "exsticky.appearance.customizedColor"
        private let default_customizedColor = UInt32(0x66ccff)
        var customizedColor: UInt32 {
            get {
                if UserDefaults.standard.integer(forKey: key_customizedColor) == 0 {
                    return default_customizedColor
                } else {
                    return UInt32(UserDefaults.standard.integer(forKey: key_customizedColor))
                }
            }
            set {
                let value = UInt32(newValue)
                UserDefaults.standard.set(value, forKey: key_customizedColor)
            }
        }
        
        // MARK: alpha
        
        private let key_alpha = "exsticky.appearance.alpha"
        private let default_alpha: Float = 0.2
        var alpha: Float {
            get {
                let value = UserDefaults.standard.float(forKey: key_alpha)
                if value != 0.0 {
                    return value
                } else {
                    UserDefaults.standard.set(default_alpha, forKey: key_alpha)
                    return default_alpha
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_alpha)
            }
        }

        private let key_width = "exsticky.appearance.width"
        private let default_width: Float = 565.7
        var width: Float {
            get {
                let value = UserDefaults.standard.float(forKey: key_width)
                if value != 0.0 {
                    return value
                } else {
                    UserDefaults.standard.set(default_width, forKey: key_width)
                    return default_width
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_width)
            }
        }

        private let key_height = "exsticky.appearance.height"
        private let default_height: Float = 400
        var height: Float {
            get {
                let value = UserDefaults.standard.float(forKey: key_height)
                if value != 0.0 {
                    return value
                } else {
                    UserDefaults.standard.set(default_width, forKey: key_height)
                    return default_height
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_height)
            }
        }
    }

    struct Behavior {
        var float = true
        var appearInAllDesktop = true
    }
}
