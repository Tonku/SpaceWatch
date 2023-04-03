//
//  NetworkTests.swift
//  SpaceWatchUITests
//
//  Created by Tony Thomas on 1/4/2023.
//

import XCTest

import XCTest
@testable import SpaceWatch

class AstronautListNetworkTests: XCTestCase {
    var sut: AstronautListURLSessionNetworkService!
    var mockURLSession: URLSessionMock!
    let timeout: TimeInterval = 10

    override func setUp() {
        super.setUp()
        mockURLSession = URLSessionMock()
        sut = AstronautListURLSessionNetworkService(session: mockURLSession)
    }

    override func tearDown() {
        sut = nil
        mockURLSession = nil

        super.tearDown()
    }

    func testFetchAstronauts_badURL() {
        sut.fullURL = "bad url"

        let expectation = self.expectation(description: "Completion is called")

        sut.fetchAstronauts { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.badURL)
            case .success:
                XCTFail("Expected failure, but got success")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testFetchAstronauts_noData() {
        mockURLSession.data = nil

        let expectation = self.expectation(description: "Completion is called")

        sut.fetchAstronauts { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.noData)
            case .success:
                XCTFail("Expected failure, but got success")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testFetchAstronauts_decodingError() {
        let corruptedData = "corrupted_data".data(using: .utf8)!
        mockURLSession.data = corruptedData

        let expectation = self.expectation(description: "Completion is called")

        sut.fetchAstronauts { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decodingError)
            case .success:
                XCTFail("Expected failure, but got success")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }

    func testFetchAstronauts_otherError() {
        let customError = NSError(domain: "test", code: 123, userInfo: nil)
        mockURLSession.error = customError

        let expectation = self.expectation(description: "Completion is called")

        sut.fetchAstronauts { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.otherError)
            case .success:
                XCTFail("Expected failure, but got success")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: timeout, handler: nil)
    }
    func testFetchDataWithInvalidStatusCode() {
        let jsonData = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "astronaut-list", withExtension: "json")!)
        
        // Set the response status code to 404
        let url = URL(string: "https://mydomain.com")!
        let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil)
        mockURLSession.response = response
        mockURLSession.data = jsonData
        
        let expectation = XCTestExpectation(description: "Fetch data with invalid status code")

        sut.fetchAstronauts { result in
            switch result {
            case .success:
                XCTFail("Expected failure due to invalid status code")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidStatusCode)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: timeout)
    }
    func testFetchAstronauts_success() {

        let jsonData = try! Data(contentsOf: Bundle(for: type(of: self)).url(forResource: "astronaut-list", withExtension: "json")!)
        
        // Set the response status code to 404
        let url = URL(string: "https://mydomain.com")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        mockURLSession.response = response
        
        mockURLSession.data = jsonData
        let expectation = self.expectation(description: "Completion is called")

        sut.fetchAstronauts { result in
            switch result {
            case .failure:
                XCTFail("Expected success, but got failure")
            case .success(let astronautsResponse):
                XCTAssertEqual(astronautsResponse.astronauts.count, 10)
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
