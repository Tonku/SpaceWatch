//
//  AstronautDetailsInteractor.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation

class AstronautDetailInteractor: AstronautDetailsInteractorProtocol {
    static let invaidId = -1
    weak var presenter: AstronautDetailsPresenterProtocol?
    var astronautId: Int = invaidId
    var networkService: AstronautDetailsNetworkServiceProtocol = AstronautDetailsNetworkService()
    
    func fetchAstranaut() {
        networkService.fetchAstronautDetails(astronautId: astronautId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let astronautDetails):
                    self?.presenter?.didFetchAstronautDetail(astronautDetail: astronautDetails)
                case .failure(let error):
                    self?.presenter?.didFailToFetchAstronautDetail(error: error)
                }
            }
        }
    }
}
