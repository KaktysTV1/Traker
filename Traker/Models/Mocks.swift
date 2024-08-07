import Foundation

final class Mocks {
    static var trackers: [TrackerCategory] = [
        TrackerCategory(
            name: "Study",
            includedTrackers: [
                Tracker(
                    id: UUID(),
                    name: "Swift",
                    schedule: [.monday, .tuesday, .wednesday, .friday, .saturday, .sunday],
                    color: .YPColorSelection10,
                    emoji: "👍🏻",
                    isPinned: true),
                Tracker(
                    id: UUID(),
                    name: "SwiftBook",
                    schedule: [.monday, .tuesday, .sunday],
                    color: .YPColorSelection2,
                    emoji: "🤘🏿",
                    isPinned: true),
                Tracker(
                    id: UUID(),
                    name: "Сomputer Science",
                    schedule: [.monday, .tuesday, .saturday, .sunday],
                    color: .YPColorSelection3,
                    emoji: "👋",
                    isPinned: false)
            ]),

        TrackerCategory(
            name: "Sport",
            includedTrackers: [
                Tracker(
                    id: UUID(),
                    name: "Gym",
                    schedule: [.monday, .tuesday, .wednesday, .friday, .sunday ],
                    color: .YPColorSelection6,
                    emoji: "💪🏻",
                    isPinned: true),
                Tracker(
                    id: UUID(),
                    name: "Football",
                    schedule: [.wednesday],
                    color: .YPColorSelection13,
                    emoji: "⚽️",
                    isPinned: false)
            ])
    ]
}
