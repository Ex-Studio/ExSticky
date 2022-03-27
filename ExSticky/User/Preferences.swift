import Foundation

struct Preferences {
    var text = Text()
    var appearence = Appearence()
    var behavior = Behavior()

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
    
    struct Behavior {
        var float: Bool = true
        var appearInAllDesktop: Bool = true
    }
}

var UserPreferences = Preferences()
