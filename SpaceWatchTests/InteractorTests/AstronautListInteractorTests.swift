//
//  AstronautListInteractorTests.swift
//  SpaceWatchTests
//
//  Created by Tony Thomas on 3/4/2023.
//

import XCTest
@testable import SpaceWatch

class MockAstronautListNetworkService: AstronautListNetworkService {
    var success: Bool = true
    func fetchAstronauts(completion: @escaping (Result<AstronautsResponse, NetworkError>) -> Void) {
        let mockAstronauts = [
            Astronaut(id: 1, name: "Astronaut A", nationality: "Country A", profileImageThumbnail: "https://example.com/imageA.jpg"),
            Astronaut(id: 2, name: "Astronaut B", nationality: "Country B", profileImageThumbnail: "https://example.com/imageB.jpg")
        ]
        if success {
            completion(.success(AstronautsResponse(astronauts: mockAstronauts)))
        } else {
            completion(.failure(NetworkError.otherError))
        }
    }
}

class MockAstronautListPresenter: AstronautListPresenterProtocol {
    var astronauts: [Astronaut]?
    var error: Error?
    
    func viewDidLoad() {}
    
    func didFetchAstronauts(astronauts: [Astronaut]) {
        self.astronauts = astronauts
    }
    
    func didFailToFetchAstronauts(error: Error) {
        self.error = error
    }
}

final class AstronautListInteractorTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testFetchAstronauts() {
        let interactor = AstronautListInteractor()
        let mockNetworkService = MockAstronautListNetworkService()
        let mockPresenter = MockAstronautListPresenter()

        interactor.networkService = mockNetworkService
        interactor.presenter = mockPresenter

        interactor.fetchAstronauts()

        let expectation = XCTestExpectation(description: "Wait for fetching astronauts")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(mockPresenter.astronauts, "Astronauts should not be nil")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
    
    func testFetchFailed() {
        let interactor = AstronautListInteractor()
        let mockNetworkService = MockAstronautListNetworkService()
        mockNetworkService.success = false
        let mockPresenter = MockAstronautListPresenter()

        interactor.networkService = mockNetworkService
        interactor.presenter = mockPresenter

        interactor.fetchAstronauts()

        let expectation = XCTestExpectation(description: "Wait for fetching astronauts")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(mockPresenter.astronauts, "Astronauts should be nil")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
      
      func testSortAstronautsByName() {
          let interactor = AstronautListInteractor()
          let mockPresenter = MockAstronautListPresenter()
          
          interactor.presenter = mockPresenter
          
          let astronauts = [
              Astronaut(id: 1, name: "Astronaut B", nationality: "Country B", profileImageThumbnail: "https://example.com/imageB.jpg"),
              Astronaut(id: 2, name: "Astronaut A", nationality: "Country A", profileImageThumbnail: "https://example.com/imageA.jpg")
          ]
          
          interactor.sortAstronautsByName(astronauts: astronauts)
          
          XCTAssertEqual(mockPresenter.astronauts?[0].name, "Astronaut A", "Astronauts should be sorted by name")
      }
    
}
