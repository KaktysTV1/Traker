import Foundation

enum Weekday: CaseIterable, Codable {
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday

    var calendarNumber: Int {
        switch self {
        case .monday:
            return 2
        case .tuesday:
            return 3
        case .wednesday:
            return 4
        case .thursday:
            return 5
        case .friday:
            return 6
        case .saturday:
            return 7
        case .sunday:
            return 1
        }
    }

    var dayNumber: Int {
        switch self {
        case .monday:
            return 1
        case .tuesday:
            return 2
        case .wednesday:
            return 3
        case .thursday:
            return 4
        case .friday:
            return 5
        case .saturday:
            return 6
        case .sunday:
            return 7
        }
    }

    var localizedName: String {
        switch self {
        case .monday:
            return L10n.Localizable.Day.monday
        case .tuesday:
            return L10n.Localizable.Day.tuesday
        case .wednesday:
            return L10n.Localizable.Day.wednesday
        case .thursday:
            return L10n.Localizable.Day.thursday
        case .friday:
            return L10n.Localizable.Day.friday
        case .saturday:
            return L10n.Localizable.Day.saturday
        case .sunday:
            return L10n.Localizable.Day.sunday
        }
    }
    var shortName: String {
        switch self {
        case .monday:
            return L10n.Localizable.Day.Short.monday
        case .tuesday:
            return L10n.Localizable.Day.Short.tuesday
        case .wednesday:
            return L10n.Localizable.Day.Short.wednesday
        case .thursday:
            return L10n.Localizable.Day.Short.thursday
        case .friday:
            return L10n.Localizable.Day.Short.friday
        case .saturday:
            return L10n.Localizable.Day.Short.saturday
        case .sunday:
            return L10n.Localizable.Day.Short.sunday
        }
    }
}
