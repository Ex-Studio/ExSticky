import Foundation
import SwiftUI

typealias C = ExStickyConstants

struct ExStickyConstants {
    static var shared = ExStickyConstants()

    static let TEXT_SIZE_MIN = 12
    static let TEXT_SIZE_MAX = 72
    static let TEXT_SIZE_DEFAULT = 24

    static let TEXT_FONT_DEFAULT = "SFMono-Regular"

    static let COLOR_CUSTOMIZED_DEFAULT = UInt32(0x66CCFF)

    static let COLOR_ALPHA_MIN: Float = 0.05
    static let COLOR_ALPHA_MAX: Float = 1.0
    static let COLOR_ALPHA_DEFAULT: Float = 0.2

    static let TEXT_WINDOW_WIDTH_MIN: Float = 100
    static let TEXT_WINDOW_HEIGHT_MIN: Float = 60
    static let TEXT_WINDOW_WIDTH_DEFAULT: Float = 565.7
    static let TEXT_WINDOW_HEIGHT_DEFAULT: Float = 400

    static let HISTORY_MAX_COUNT = 36

    /// 每新建多少个窗口出现一次买咖啡的消息
    static let SUPPORT_INFO_FREQUENCY = 100

    static let MENU_TITLE_HISTORY = "History"
    static let MENU_TITLE_HELP = "Help"
    static let MENU_TITLE_WINDOW = "Window"
    static let MENU_TITLE_WINDOW_OPACITY = "Set Opacity"
    static let MENU_TITLE_WINDOW_OPACITY_SUBMENU = "Opacity Submenu"
    static let MENU_TITLE_WINDOW_COLOR = "Set Color"
    static let MENU_TITLE_WINDOW_COLOR_SUBMENU = "Color Submenu"
    
    static let UI_FIRST_WINDOW_X = 20
    static let UI_FIRST_WINDOW_Y_FROM_TOP_LEFT = 40 // will be grate if not hide menu bar
    static let UI_WINDOW_HORIZONTAL_DISTANCE = 20
    static let UI_WINDOW_VERTICLE_DISTANCE = 26
    static let UI_WINDOW_CYCLE = 8
}
