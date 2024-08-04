//
//  TrakerTests.swift
//  TrakerTests
//
//  Created by Андрей Чупрыненко on 02.08.2024.
//

import XCTest
import SnapshotTesting
@testable import Traker

final class TrakerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewController() {
            let vc = TrackersViewController()
            
        assertSnapshot(matching: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
        }


    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
