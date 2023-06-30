import AppKit
import Foundation
import XCLog

var UserSettings = ExStickySettings.shared

struct ExStickySettings {
    public static var shared = ExStickySettings()

    public var text = Text()
    public var appearence = Appearence()
    public var behavior = Behavior()

    // MARK: - Text

    struct Text {
        private let key_size = "exsticky.text.size"
        var size: Int {
            set {
                UserDefaults.standard.set(newValue, forKey: key_size)
            }
            get {
                let size = UserDefaults.standard.integer(forKey: key_size)
                if size != 0 {
                    return size
                } else { // this key not exist
                    UserDefaults.standard.set(C.TEXT_SIZE_DEFAULT, forKey: key_size)
                    return C.TEXT_SIZE_DEFAULT
                }
            }
        }

        private let key_font = "exsticky.text.font"
        var font: String {
            set {
                if NSFontManager.shared.availableFonts.contains(newValue) {
                    UserDefaults.standard.set(newValue, forKey: key_font)
                } else {
                    UserDefaults.standard.set(C.TEXT_FONT_DEFAULT, forKey: key_font)
                    XCLog(.error, "no such font in the user's system")
                }
            }
            get {
                if let f = UserDefaults.standard.string(forKey: key_font) {
                    if NSFontManager.shared.availableFonts.contains(f) {
                        return f
                    } else {
                        return C.TEXT_FONT_DEFAULT
                    }

                } else { // this key not exist
                    UserDefaults.standard.set(C.TEXT_FONT_DEFAULT, forKey: key_font)
                    return C.TEXT_FONT_DEFAULT
                }
            }
        }
    }

    struct Appearence {
        // MARK: theme

        private let key_color_theme = "exsticky.appearance.color_theme"
        var color_theme: ExStickyColorTheme {
            get {
                if let value = UserDefaults.standard.string(forKey: key_color_theme) {
                    if value == ExStickyColorTheme.single.rawValue {
                        return .single
                    } else if value == ExStickyColorTheme.random.rawValue {
                        return .random
                    } else { // error
                        XCLog(.error)
                        return .single
                    }
                } else { // default value
                    UserDefaults.standard.set("random", forKey: key_color_theme)
                    return .random
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
        private let default_color = ExStickyPresetColor.blue.rawValue
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
        var customizedColor: UInt32 {
            get {
                if UserDefaults.standard.integer(forKey: key_customizedColor) == 0 {
                    return C.COLOR_CUSTOMIZED_DEFAULT
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
        var alpha: Float {
            get {
                let value = UserDefaults.standard.float(forKey: key_alpha)
                if value != 0.0 {
                    return value
                } else {
                    UserDefaults.standard.set(C.COLOR_ALPHA_DEFAULT, forKey: key_alpha)
                    return C.COLOR_ALPHA_DEFAULT
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_alpha)
            }
        }

        private let key_width = "exsticky.appearance.width"
        var width: Float {
            get {
                let value = UserDefaults.standard.float(forKey: key_width)
                if value != 0.0 {
                    return value
                } else {
                    UserDefaults.standard.set(C.TEXT_WINDOW_WIDTH_DEFAULT, forKey: key_width)
                    return C.TEXT_WINDOW_WIDTH_DEFAULT
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_width)
            }
        }

        private let key_height = "exsticky.appearance.height"
        var height: Float {
            get {
                let value = UserDefaults.standard.float(forKey: key_height)
                if value != 0.0 {
                    return value
                } else {
                    UserDefaults.standard.set(C.TEXT_WINDOW_HEIGHT_DEFAULT, forKey: key_height)
                    return C.TEXT_WINDOW_HEIGHT_DEFAULT
                }
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key_height)
            }
        }
    }

    struct Behavior {
        private let key_float = "exsticky.appearance.float"
        var float: Bool {
            get {
                return !UserDefaults.standard.bool(forKey: key_float) // default true
            }
            set {
                UserDefaults.standard.set(!newValue, forKey: key_float)
            }
        }

        private let key_appearOnAllDesktop = "exsticky.appearance.appearOnAllDesktop"
        var appearOnAllDesktop: Bool {
            get {
                return !UserDefaults.standard.bool(forKey: key_appearOnAllDesktop) // default true
            }
            set {
                UserDefaults.standard.set(!newValue, forKey: key_appearOnAllDesktop)
            }
        }
    }
}
