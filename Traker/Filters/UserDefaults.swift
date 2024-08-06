import Foundation

final class FilterStorage {
    // MARK: - Properties:
    var filter: Filters {
        get {
            Filters(rawValue: UserDefaults.standard.string(forKey: "selectedFilter") ?? "") ?? .allTrackers
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedFilter")
        }
    }
}
