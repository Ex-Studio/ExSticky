import Cocoa

extension NSTextView {
    func moveLineUp() {
        let old_cursor_position = self.selectedRanges.first!.rangeValue.location
        let old_string = self.string

        let lines = old_string.components(separatedBy: .newlines)

        var current_line_num = 0
        var line_end_position = 0
        for i in 0 ..< lines.count {
            line_end_position += lines[i].count
            if old_cursor_position <= line_end_position {
                current_line_num = i
                break
            }
            line_end_position += 1 // add \n
        }

        if current_line_num < lines.count, current_line_num > 0 { // not consider first line
            let current_line_string = lines[current_line_num]
            let previous_line_num = current_line_num - 1
            let previous_line_string = lines[previous_line_num]
            // exchange two lines
            self.insertText(current_line_string + "\n" + previous_line_string,
                            replacementRange: NSRange(
                                location: line_end_position - current_line_string.count - 1 - previous_line_string.count,
                                length: previous_line_string.count + 1 + current_line_string.count
                            ))
            // reset position of cusor
            self.setSelectedRange(NSRange(
                location: old_cursor_position - previous_line_string.count - 1,
                length: 0
            ))
        }
    }

    func moveLineDown() {
        let old_cursor_position = self.selectedRanges.first!.rangeValue.location
        let old_string = self.string

        let lines = old_string.components(separatedBy: .newlines)

        var current_line_num = 0
        var line_end_position = 0
        for i in 0 ..< lines.count {
            line_end_position += lines[i].count
            if old_cursor_position <= line_end_position {
                current_line_num = i
                break
            }
            line_end_position += 1 // add \n
        }
        // exchange two lines
        if current_line_num < lines.count - 1, current_line_num >= 0 { // not consider last line
            let current_line_string = lines[current_line_num]
            let next_line_num = current_line_num + 1
            let next_line_string = lines[next_line_num]
            self.insertText(next_line_string + "\n" + current_line_string,
                            replacementRange: NSRange(
                                location: line_end_position - current_line_string.count,
                                length: next_line_string.count + 1 + current_line_string.count
                            ))
            // reset position of cusor
            self.setSelectedRange(NSRange(
                location: old_cursor_position + next_line_string.count + 1,
                length: 0
            ))
        }
    }

    func indentLine() {
        let old_cursor_position = self.selectedRanges.first!.rangeValue.location
        let old_string = self.string

        let lines = old_string.components(separatedBy: .newlines)

        var current_line_num = 0
        var line_end_position = 0
        for i in 0 ..< lines.count {
            line_end_position += lines[i].count
            if old_cursor_position <= line_end_position {
                current_line_num = i
                break
            }
            line_end_position += 1 // add \n
        }
        let current_line_string = lines[current_line_num]

        // insert 4 spaces at start of line
        self.insertText("    ",
                        replacementRange: NSRange(
                            location: line_end_position - current_line_string.count,
                            length: 0
                        ))
    }

    func outdentLine() {
        let old_cursor_position = self.selectedRanges.first!.rangeValue.location
        let old_string = self.string

        let lines = old_string.components(separatedBy: .newlines)

        var current_line_num = 0
        var line_end_position = 0
        for i in 0 ..< lines.count {
            line_end_position += lines[i].count
            if old_cursor_position <= line_end_position {
                current_line_num = i
                break
            }
            line_end_position += 1 // add \n
        }
        let current_line_string = lines[current_line_num]

        // insert 4 spaces at start of line
        if current_line_string.count >= 4 {
            if current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 0)] == " ",
               current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 1)] == " ",
               current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 2)] == " ",
               current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 3)] == " " {
                self.insertText("",
                                replacementRange: NSRange(
                                    location: line_end_position - current_line_string.count,
                                    length: 4
                                ))
            }
        }
    }

    func toggleUnorderedList() {
        let old_cursor_position = self.selectedRanges.first!.rangeValue.location
        let old_string = self.string

        let lines = old_string.components(separatedBy: .newlines)

        var current_line_num = 0
        var line_end_position = 0
        for i in 0 ..< lines.count {
            line_end_position += lines[i].count
            if old_cursor_position <= line_end_position {
                current_line_num = i
                break
            }
            line_end_position += 1 // add \n
        }
        let current_line_string = lines[current_line_num]

        if current_line_string.count < 2 {
            self.insertText("- ",
                            replacementRange: NSRange(
                                location: line_end_position - current_line_string.count,
                                length: 0
                            ))
        } else {
            if current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 0)] == "-" || current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 0)] == "*",
               current_line_string[current_line_string.index(current_line_string.startIndex, offsetBy: 1)] == " " {
                // delete unordered list
                self.insertText("",
                                replacementRange: NSRange(
                                    location: line_end_position - current_line_string.count,
                                    length: 2
                                ))
            } else {
                // add unordered list
                self.insertText("- ",
                                replacementRange: NSRange(
                                    location: line_end_position - current_line_string.count,
                                    length: 0
                                ))
            }
        }
    }
}
