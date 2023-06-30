import Foundation

// https://stackoverflow.com/a/27191772/18596242
extension StringProtocol {
    func dropping<S: StringProtocol>(prefix: S) -> SubSequence { hasPrefix(prefix) ? dropFirst(prefix.count) : self[...] }
    var hex2uint32: UInt32? { UInt32(dropping(prefix: "0x"), radix: 16) }
    var uint322hex: String {
        let hex = String(UInt32(self) ?? 0, radix: 16)
        return "0x" + hex
    }
}
