//
//  AstronautDetailsTests.swift
//  SpaceWatchTests
//
//  Created by Tony Thomas on 2/4/2023.
//

import XCTest
@testable import SpaceWatch

class AstronautDetailsNetworkTests: XCTestCase {
    var sut: AstronautDetailsNetworkService!
    var urlBuilder: URLBuilder!
    var session: URLSessionMock!
    let timeout: TimeInterval = 1
    
    override func setUp() {
        super.setUp()
        urlBuilder = DefaultURLBuilder()
        session = URLSessionMock()
        sut = AstronautDetailsNetworkService(session: session, urlBuilder: urlBuilder)
    }
    
    override func tearDown() {
        sut = nil
        urlBuilder = nil
        session = nil
        super.tearDown()
    }
    
    func testFetchAstronautDetails_badURL() {
        let urlBuilder = InvalidURLBuilder()
        sut = AstronautDetailsNetworkService(session: session, urlBuilder: urlBuilder)
        
        let expectation = self.expectation(description: "Completion handler called")
        sut.fetchAstronautDetails(astronautId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.badURL)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func testFetchAstronautDetails_otherError() {
        session.error = NSError(domain: "TestError", code: 0)
        
        let expectation = self.expectation(description: "Completion handler called")
        sut.fetchAstronautDetails(astronautId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.otherError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func testFetchAstronautDetails_noData() {
        session.data = nil
        
        let expectation = self.expectation(description: "Completion handler called")
        sut.fetchAstronautDetails(astronautId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.noData)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func testFetchAstronautDetails_decodingError() {
        session.data = "corrupted_data".data(using: .utf8)!
        
        let expectation = self.expectation(description: "Completion handler called")
        sut.fetchAstronautDetails(astronautId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decodingError)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    func testFetchAstronautDetails_wrong_statuscode() {
        let jsonString = """
        {
            "id": 309,
            "name": "Don L. Lind",
            "nationality": "American",
            "profile_image": "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/astronaut_images/don2520l.2520lind_image_20181202091446.jpg",
            "bio": "Test bio",
            "date_of_birth": "1930-05-18"
        }
        """
        // Set the response status code to 404
        let url = URL(string: "https://mydomain.com")!
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        session.response = response
        session.data = jsonString.data(using: .utf8)
        let expectation = self.expectation(description: "Completion handler called")
        sut.fetchAstronautDetails(astronautId: 1) { result in
            switch result {
            case .success(_):
                XCTFail("Expected failure due to invalid status code")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidStatusCode)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    func testFetchAstronautDetails_success() {
        let jsonString = """
        {
            "id": 309,
            "name": "Don L. Lind",
            "nationality": "American",
            "profile_image": "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/astronaut_images/don2520l.2520lind_image_20181202091446.jpg",
            "bio": "Test bio",
            "date_of_birth": "1930-05-18"
        }
        """
        let url = URL(string: "https://mydomain.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        session.response = response
        session.data = jsonString.data(using: .utf8)
        
        let expectation = self.expectation(description: "Completion handler called")
        sut.fetchAstronautDetails(astronautId: 1) { result in
            switch result {
            case .success(let astronautDetails):
                XCTAssertEqual(astronautDetails.name, "Don L. Lind")
                XCTAssertEqual(astronautDetails.nationality, "American")
                XCTAssertEqual(astronautDetails.profileImage, "https://spacelaunchnow-prod-east.nyc3.digitaloceanspaces.com/media/astronaut_images/don2520l.2520lind_image_20181202091446.jpg")
                XCTAssertEqual(astronautDetails.bio, "Test bio")
                XCTAssertEqual(astronautDetails.dateOfBirth, "1930-05-18")
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeout)
    }
    
}
