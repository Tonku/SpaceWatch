//
//  AstronautDetailsNetwork.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 2/4/2023.
//

import Foundation

protocol AstronautDetailsNetworkServiceProtocol {
    func fetchAstronautDetails(astronautId: Int, completion: @escaping (Result<AstronautDetails, NetworkError>) -> Void)
}

final class AstronautDetailsNetworkService: AstronautDetailsNetworkServiceProtocol {
    
    private let session: any URLSessionProtocol
    private let urlBuilder: URLBuilder

    init(session: any URLSessionProtocol = URLSession.shared, urlBuilder: URLBuilder = DefaultURLBuilder()) {
        self.session = session
        self.urlBuilder = urlBuilder
    }

    func fetchAstronautDetails(astronautId: Int, completion: @escaping (Result<AstronautDetails, NetworkError>) -> Void) {
        guard let url = urlBuilder.buildAstronautDetailsURL(astronautId: astronautId) else {
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
                let astronautDetails = try JSONDecoder().decode(AstronautDetails.self, from: data)
                completion(.success(astronautDetails))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        task.resume()
    }
}

protocol URLBuilder {
    func buildAstronautDetailsURL(astronautId: Int) -> URL?
}

struct DefaultURLBuilder: URLBuilder {
    private let baseURL = "http://spacelaunchnow.me/api/3.5.0/astronaut/"

    func buildAstronautDetailsURL(astronautId: Int) -> URL? {
        let urlString = baseURL + String(astronautId)
        return URL(string: urlString)
      //  return URL(string: "https://pub-2aea2b1666cf44c1901960c387c2bf29.r2.dev/details.json")
    }
}
