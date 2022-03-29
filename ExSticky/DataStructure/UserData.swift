import Foundation
import XCLog

var UserData = ExStickyData.shared

struct ExStickyData {
    static var shared = ExStickyData()

    var statistic = Statistic()

    struct Statistic {
        private let key_times = "exsticky.statistic.times"
        /// keep track of how many times the user opens a new window
        var times: Int {
            set {
                UserDefaults.standard.set(newValue, forKey: key_times)
            }
            get {
                UserDefaults.standard.integer(forKey: key_times) // default is 0
            }
        }
    }
}
