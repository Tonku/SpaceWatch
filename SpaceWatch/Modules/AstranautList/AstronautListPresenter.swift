//
//  AstronautListPresenter.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

class AstronautListPresenter:  AstronautListPresenterProtols {


    weak var view: AstronautListViewProtocol?
    var interactor: AstronautListInteractorProtocol?
    var router: MasterCoordinator?
    
    func viewDidLoad() {
        interactor?.fetchAstronauts()
    }
    
    func didSelectAstronaut(astronaut: AatronautCellViewModelProtocol) {
        router?.openAstronautDetailModule(astronautId: astronaut.id)
    }
    
    func userTappedToSortItems(astronautsVM: [AatronautCellViewModelProtocol]) {
        interactor?.sortAstronautsByName(astronauts: astronautsVM.map { $0.astronaut })
    }
    
    func didFetchAstronauts(astronauts: [Astronaut]) {
        view?.displayAstronauts(astronauts: astronauts.map {AstronautCellViewModel(astronaut: $0) })
    }
    
    func didFailToFetchAstronauts(error: Error) {
        view?.showError(error: error)
    }
}
