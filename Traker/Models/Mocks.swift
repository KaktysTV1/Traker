import Foundation

final class Mocks {
    static var trackers: [TrackerCategory] = [
        TrackerCategory(
            name: "Study",
            includedTrackers: [
                Tracker(
                    id: UUID(),
                    name: "Swift",
                    schedule: [.Monday, .Tuesday, .Wednesday, .Friday, .Saturday, .Sunday],
                    color: .YPColorSelection10,
                    emoji: "👍🏻"),
                Tracker(
                    id: UUID(),
                    name: "SwiftBook",
                    schedule: [.Monday, .Tuesday, .Sunday],
                    color: .YPColorSelection2,
                    emoji: "🤘🏿"),
                Tracker(
                    id: UUID(),
                    name: "Сomputer Science",
                    schedule: [.Monday, .Tuesday,  .Saturday, .Sunday],
                    color: .YPColorSelection3,
                    emoji: "👋")
            ]),
        
        TrackerCategory(
            name: "Sport",
            includedTrackers: [
                Tracker(
                    id: UUID(),
                    name: "Gym",
                    schedule: [.Monday, .Tuesday, .Wednesday, .Friday, .Sunday,],
                    color: .YPColorSelection6,
                    emoji: "💪🏻"),
                Tracker(
                    id: UUID(),
                    name: "Football",
                    schedule: [.Wednesday],
                    color: .YPColorSelection13,
                    emoji: "⚽️")
            ])
    ]
}
