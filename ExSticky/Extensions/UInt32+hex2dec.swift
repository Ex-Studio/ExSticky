// UInt32+threeInt.swift

import Foundation

extension StringProtocol {
    func dropping<S: StringProtocol>(prefix: S) -> SubSequence { hasPrefix(prefix) ? dropFirst(prefix.count) : self[...] }
    var hex2uint32: UInt32? { UInt32(dropping(prefix: "0x"), radix: 16) }
}
