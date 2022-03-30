import Cocoa

struct ExStickyHistoryItem: Codable {
    var content: String
    var createdTime = Date()

    init(_ text: String) {
        self.content = text
    }
}

// pass history in instead of using `UserData.history` directly, which will cause simultaneous access
func SetupHistoryMenuItems(history: [ExStickyHistoryItem]) {
    let HistoryMenu = NSApp.mainMenu!.item(withTitle: C.MENU_TITLE_HISTORY)
    // remove all history in menu bar, leave aside `Clear All` and `Separator`
    while HistoryMenu!.submenu!.items.count >= 3 {
        HistoryMenu!.submenu!.removeItem(at: 2)
    }
    if history.count != 0 {
        HistoryMenu!.submenu!.items[0].isEnabled = true
        let sortedHistory = history.sorted { h1, h2 in
            h1.createdTime > h2.createdTime
        }
        // add all history in `UserData.history`
        _ = sortedHistory.map { history in
            HistoryMenu!.submenu!.addItem(NSMenuItem(title: history.content, action: #selector(NSApp.CopyToSystemPasteboard(_:)), keyEquivalent: ""))
        }
    } else {
        HistoryMenu!.submenu!.item(at: 0)!.isEnabled = false // `Clear All` button
    }
}
