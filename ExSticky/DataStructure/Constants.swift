// Constants.swift

import Foundation

let C = ExStickyConstants.shared

struct ExStickyConstants {
    static var shared = ExStickyConstants()

    let TEXT_SIZE_MIN = 12
    let TEXT_SIZE_DEFAULT = 24
    let TEXT_SIZE_MAX = 72

    let TEXT_FONT_DEFAULT = "SFMono-Regular"

    let COLOR_CUSTOMIZED_DEFAULT = UInt32(0x66CCFF)

    let COLOR_ALPHA_DEFAULT: Float = 0.2

    let TEXT_WINDOW_MIN_WIDTH: Float = 100
    let TEXT_WINDOW_MIN_HEIGHT: Float = 60

    let TEXT_WINDOW_WIDTH_DEFAULT: Float = 565.7
    let TEXT_WINDOW_HEIGHT_DEFAULT: Float = 400
}
