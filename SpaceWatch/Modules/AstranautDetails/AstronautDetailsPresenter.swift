//
//  AstronautDetailsPresenter.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import Foundation

class AstronautDetailPresenter: AstronautDetailsPresenterProtocol {

    weak var view: AstronautDetailsViewProtocol?
    var interactor: AstronautDetailsInteractorProtocol?
    
    func viewDidLoad() {
        interactor?.fetchAstranaut()
    }
    
    func didFetchAstronautDetail(astronautDetail: AstronautDetails) {
        view?.displayAstronautDetail(astronautDetails: AstronautDetailsViewModel(astronaut: astronautDetail))
    }
    
    func didFailToFetchAstronautDetail(error: Error) {
        view?.showError(error: error)
    }
    func fetchAstronautDetail(astronautId: String) {
        
    }
}
