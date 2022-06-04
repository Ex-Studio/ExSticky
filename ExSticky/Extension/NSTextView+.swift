import Cocoa

extension NSTextView {
    func lineStartPointInert(with string: String) {
        guard
            let layoutManager = self.layoutManager,
            let range = self.selectedRanges.first?.rangeValue
        else { return }
        // deal with the end of line
        let glyphIndex = range.lowerBound == layoutManager.numberOfGlyphs ? range.lowerBound - 1 : range.lowerBound
        var effectiveRange = NSRange()
        layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: &effectiveRange)
        print(effectiveRange)
        insertText(string, replacementRange: NSRange(location: effectiveRange.location, length: 0))
    }
}

