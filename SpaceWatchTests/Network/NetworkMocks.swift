//
//  NetworkMocks.swift
//  SpaceWatchUITests
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation
@testable import SpaceWatch


class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    func resume() {
        closure()
    }
}

class URLSessionMock: URLSessionProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // data and error can be set to provide data or an error
    var data: Data?
    var error: Error?

    // response can be set to provide a custom HTTPURLResponse
    var response: HTTPURLResponse?

    func dataTask(with url: URL, completionHandler: @escaping CompletionHandler) -> URLSessionDataTaskMock {
        let data = self.data
        let error = self.error
        let response = self.response ?? HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        return URLSessionDataTaskMock {
            completionHandler(data, response, error)
        }
    }
}


class InvalidURLBuilder: URLBuilder {
    func buildAstronautDetailsURL(astronautId: Int) -> URL? {
        return nil
    }
}
