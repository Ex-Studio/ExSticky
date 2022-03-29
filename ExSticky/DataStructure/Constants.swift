// Constants.swift

import Foundation

let C = ExStickyConstants.shared

struct ExStickyConstants {
    static var shared = ExStickyConstants()

    let TEXT_SIZE_MIN = 12
    let TEXT_SIZE_MAX = 72
    let TEXT_SIZE_DEFAULT = 24

    let TEXT_FONT_DEFAULT = "SFMono-Regular"

    let COLOR_CUSTOMIZED_DEFAULT = UInt32(0x66CCFF)

    let COLOR_ALPHA_MIN: Float = 0.05
    let COLOR_ALPHA_MAX: Float = 1.0
    let COLOR_ALPHA_DEFAULT: Float = 0.2

    let TEXT_WINDOW_WIDTH_MIN: Float = 100
    let TEXT_WINDOW_HEIGHT_MIN: Float = 60
    let TEXT_WINDOW_WIDTH_DEFAULT: Float = 565.7
    let TEXT_WINDOW_HEIGHT_DEFAULT: Float = 400
}
