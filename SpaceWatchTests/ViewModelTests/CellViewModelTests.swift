//
//  CellViewModelTests.swift
//  SpaceWatchTests
//
//  Created by Tony Thomas on 2/4/2023.
//

import XCTest
@testable import SpaceWatch

final class CellViewModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAstronautCellViewModel() {
        let astronaut = Astronaut(id: 1, name: "John Doe", nationality: "American", profileImageThumbnail: "https://mydomain.com/image.jpg")
        let viewModel = AstronautCellViewModel(astronaut: astronaut)

        XCTAssertEqual(viewModel.id, 1)
        XCTAssertEqual(viewModel.name, "John Doe")
        XCTAssertEqual(viewModel.nationality, "American")
        XCTAssertEqual(viewModel.profileImageThumbnail, URL(string: "https://mydomain.com/image.jpg")!)
    }
}
