import Foundation
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
