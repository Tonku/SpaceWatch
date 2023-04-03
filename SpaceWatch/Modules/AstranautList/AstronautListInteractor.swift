//
//  AstronautListInteractor.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation

class AstronautListInteractor: AstronautListInteractorProtocol {
    weak var presenter: AstronautListPresenterProtocol?
    var networkService: AstronautListNetworkService?
    
    func fetchAstronauts() {
        networkService?.fetchAstronauts(completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let astranautResponse):
                    self?.presenter?.didFetchAstronauts(astronauts: astranautResponse.astronauts)
                case .failure(let error):
                    self?.presenter?.didFailToFetchAstronauts(error: error)
                }
            }
        })
    }
    
    func sortAstronautsByName(astronauts: [Astronaut]) {
        let sortedAstronauts = astronauts.sorted { $0.name < $1.name }
        presenter?.didFetchAstronauts(astronauts: sortedAstronauts)
    }
}




