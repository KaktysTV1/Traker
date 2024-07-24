//
//  Mocks.swift
//  Traker
//
//  Created by Андрей Чупрыненко on 24.07.2024.
//

import Foundation

final class Mocks {
    static var trackers: [TrackerCategory] = [
        TrackerCategory(
            name: "Study",
            includedTrackers: [
                Tracker(
                    id: UUID(),
                    name: "Swift",
                    schedule: [.Monday, .Tuesday, .Wednesday, .Friday, .Saturday, .Sunday]),
                Tracker(
                    id: UUID(),
                    name: "SwiftBook",
                    schedule: [.Monday, .Tuesday, .Sunday]),
                Tracker(
                    id: UUID(),
                    name: "Сomputer Science",
                    schedule: [.Monday, .Tuesday,  .Saturday, .Sunday])
            ]),
        
        TrackerCategory(
            name: "Sport",
            includedTrackers: [
                Tracker(
                    id: UUID(),
                    name: "Gym",
                    schedule: [.Monday, .Tuesday, .Wednesday, .Friday, .Sunday,]),
                Tracker(
                    id: UUID(),
                    name: "Football",
                    schedule: [.Wednesday])
            ])
    ]
}
