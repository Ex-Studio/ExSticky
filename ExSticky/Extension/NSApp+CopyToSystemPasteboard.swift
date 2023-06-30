import Cocoa

extension NSApplication {
    @objc
    func CopyToSystemPasteboard(_ sender: NSMenuItem) {
        let menuitem = sender as NSMenuItem
        let title = menuitem.title

        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(title, forType: NSPasteboard.PasteboardType.string)
    }
}
