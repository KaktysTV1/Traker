import Foundation

enum Filters: String, CaseIterable {
    case allTrackers
    case todayTrackers
    case completedTrackers
    case notCompletedTrackers

    var name: String {
        switch self {
        case .allTrackers:
            return L10n.Localizable.Filter.allTrackersTitle
        case .todayTrackers:
            return L10n.Localizable.Filter.todayTrackersTitle
        case .completedTrackers:
            return L10n.Localizable.Filter.completedTrackersTitle
        case .notCompletedTrackers:
            return L10n.Localizable.Filter.notCompletedTitle
        }
    }
}
