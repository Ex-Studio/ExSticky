import Cocoa

extension NSTextView {
//    func lineStartPointInert(with string: String) {
//        guard
//            let layoutManager = self.layoutManager,
//            let range = self.selectedRanges.first?.rangeValue
//        else { return }
//        // deal with the end of line
//        let glyphIndex = range.lowerBound == layoutManager.numberOfGlyphs ? range.lowerBound - 1 : range.lowerBound
//        var effectiveRange = NSRange()
//        layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: &effectiveRange)
//        print(effectiveRange)
//        insertText(string, replacementRange: NSRange(location: effectiveRange.location, length: 0))
//    }

    func moveLineUp() {
        let previous_cusor_position = self.selectedRanges.first!.rangeValue.location
        let previous_string = self.string

        let lines = previous_string.components(separatedBy: .newlines)

        var current_line_num = 0
        var line_end_position = 0
        for i in 0 ..< lines.count {
            line_end_position += lines[i].count
            if previous_cusor_position <= line_end_position {
                current_line_num = i
                break
            }
            line_end_position += 1 // add \n
        }

        if current_line_num < lines.count, current_line_num > 0 { // not consider first line
            // exchange line
            let current_line_string = lines[current_line_num]
            let current_line_is_last_line = current_line_num != lines.count - 1
            let previous_line_num = current_line_num - 1
            let previous_line_string = lines[previous_line_num]
            // delete current line
            self.insertText("",
                            replacementRange: NSRange(
                                location: line_end_position - current_line_string.count,
                                length: current_line_is_last_line ?
                                    current_line_string.count + 1 :
                                    current_line_string.count
                            ))
            // insert current_line_string before previous line
            self.insertText(current_line_string + "\n",
                            replacementRange: NSRange(
                                location: line_end_position - current_line_string.count - 1 - previous_line_string.count,
                                length: 0
                            ))
            // reset position of cusor
            self.setSelectedRange(NSRange(
                location: previous_cusor_position - lines[current_line_num - 1].count - 1,
                length: 0
            ))
        }
    }
}
