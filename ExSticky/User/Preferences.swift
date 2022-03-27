import Foundation

struct Preferences {
    var text = Text()
    var appearence = Appearence()

    // ---

    struct Text {
        var size: Float = 24.0
        var font = "SF Mono"
    }

    struct Appearence {
        var alpha: Float = 0.2
        var color: UInt32 = 0x66CCFF // TODO: add get set
        var width: Float = 400 * sqrt(2)
        var height: Float = 400
    }
}

var UserPreferences = Preferences()
