import Foundation

struct Preferences {
    static var shared = Preferences()

    var text = Text()
    var appearence = Appearence()
    var behavior = Behavior()

    // ---

    struct Text {
        var size: Float {
            set {
                UserDefaults.standard.set(newValue, forKey: "Text.size")
            }
            get {
                let size = UserDefaults.standard.float(forKey: "Text.size")
                if size != 0.0 {
                    return size
                } else {
                    return 24.0
                }
            }
        }

        var font = "SF Mono"
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

var UserPreferences = Preferences.shared
//
// func haha(){
//    UserDefaults.standard.
// }
