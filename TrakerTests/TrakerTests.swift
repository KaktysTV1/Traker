//
//  TrakerTests.swift
//  TrakerTests
//
//  Created by Андрей Чупрыненко on 02.08.2024.
//

import XCTest
import SnapshotTesting
@testable import Traker

final class TrackerTests: XCTestCase {
    func testingTrackersViewControllerLightStyle() {
        let viewController = TrackersViewController()

        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

    func testingTrackersViewControllerDarkStyle() {
        let viewController = TrackersViewController()

        assertSnapshot(matching: viewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
    }
}
