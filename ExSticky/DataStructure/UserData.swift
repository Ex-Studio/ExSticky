import Cocoa
import XCLog

var UserData = ExStickyData.shared

struct ExStickyHistoryItem: Codable {
    var content: String
    var createdTime = Date()

    init(_ text: String) {
        self.content = text
    }
}

struct ExStickyData {
    static var shared = ExStickyData()

    private let key_data_times = "exsticky.data.times"
    /// keep track of how many times the user opens a new window
    var times: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: key_data_times)
        }
        get {
            UserDefaults.standard.integer(forKey: key_data_times) // default is 0
        }
    }

    private var key_data_history = "exsticky.data.history"
    /// user history array
    var history: [ExStickyHistoryItem] {
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.set(data, forKey: key_data_history)
                // update history menu
                SetupHistoryMenuItems(history: newValue)
            } else {
                XCLog(.error)
            }
        }
        get {
            if let data = UserDefaults.standard.value(forKey: key_data_history) as? Data,
               let array = try? PropertyListDecoder().decode([ExStickyHistoryItem].self, from: data) {
                return array
            } else {
                XCLog(.error)
                return []
            }
        }
    }
}

// pass history in instead of using `UserData.history` directly, which will cause simultaneous access
func SetupHistoryMenuItems(history: [ExStickyHistoryItem]) {
    let HistoryMenu = NSApp.mainMenu!.item(withTitle: C.MENU_TITLE_HISTORY)
    // remove all history in menu bar, leave aside `Clear All` and `Separator`
    while HistoryMenu!.submenu!.items.count != 2 {
        HistoryMenu!.submenu!.removeItem(at: 2)
    }
    let sortedHistory = history.sorted { h1, h2 in
        h1.createdTime > h2.createdTime
    }
    // add all history in `UserData.history`
    _ = sortedHistory.map { history in
        HistoryMenu!.submenu!.addItem(NSMenuItem(title: history.content, action: #selector(NSApp.CopyToSystemPasteboard(_:)), keyEquivalent: ""))
    }
}

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
