import Foundation

let C = ExStickyConstants.shared

struct ExStickyConstants {
    static var shared = ExStickyConstants()

    let TEXT_SIZE_MIN = 12
    let TEXT_SIZE_MAX = 72
    let TEXT_SIZE_DEFAULT = 24

    let TEXT_FONT_DEFAULT = "SFMono-Regular" // FIXME: 在中文的机器上有这个字体嘛 不会显示成SFMono-常规什么的吧 可能会直接崩掉

    let COLOR_CUSTOMIZED_DEFAULT = UInt32(0x66CCFF)

    let COLOR_ALPHA_MIN: Float = 0.05
    let COLOR_ALPHA_MAX: Float = 1.0
    let COLOR_ALPHA_DEFAULT: Float = 0.2

    let TEXT_WINDOW_WIDTH_MIN: Float = 100
    let TEXT_WINDOW_HEIGHT_MIN: Float = 60
    let TEXT_WINDOW_WIDTH_DEFAULT: Float = 565.7
    let TEXT_WINDOW_HEIGHT_DEFAULT: Float = 400

    let HISTORY_MAX_COUNT = 7

    /// 每新建多少个窗口出现一次买咖啡的消息
    let SUPPORT_INFO_FREQUENCY = 64

    let MENU_TITLE_HISTORY = String(localized: "History")

    let UI_FIRST_WINDOW_X = 20
    let UI_FIRST_WINDOW_Y_FROM_TOP_LEFT = 40 // will be grate if not hide menu bar
    let UI_WINDOW_HORIZONTAL_DISTANCE = 20
    let UI_WINDOW_VERTICLE_DISTANCE = 26
    let UI_WINDOW_CYCLE = 8
}
