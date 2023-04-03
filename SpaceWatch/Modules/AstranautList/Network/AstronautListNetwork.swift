//
//  Network.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case decodingError
    case noData
    case otherError
    case invalidStatusCode
}

protocol AstronautListNetworkService {
    func fetchAstronauts(completion: @escaping (Result<AstronautsResponse, NetworkError>) -> Void)
}

final class AstronautListURLSessionNetworkService: AstronautListNetworkService {
    var fullURL = "http://spacelaunchnow.me/api/3.5.0/astronaut/"
    //var fullURL = "https://pub-2aea2b1666cf44c1901960c387c2bf29.r2.dev/db.json"
    private let session: any URLSessionProtocol

    init(session: any URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchAstronauts(completion: @escaping (Result<AstronautsResponse, NetworkError>) -> Void) {
        guard let url = URL(string: fullURL) else {
            completion(.failure(.badURL))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.otherError))
                return
            }
            guard let data = data, !data.isEmpty else {
                completion(.failure(.noData))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                  completion(.failure(.invalidStatusCode))
                  return
            }
            do {
                let astronautsResponse = try JSONDecoder().decode(AstronautsResponse.self, from: data)
                completion(.success(astronautsResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
   
}
protocol URLSessionProtocol {
    associatedtype dta: URLSessionDataTaskProtocol
    func dataTask(with url: URL, completionHandler: @escaping @Sendable (Data?,    URLResponse?, Error?) -> Void) -> dta
}
extension URLSession: URLSessionProtocol {
    typealias dta = URLSessionDataTask
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {
}
protocol URLSessionDataTaskProtocol {
    func resume()
}




