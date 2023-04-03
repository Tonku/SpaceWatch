//
//  AstronautListProtocols.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

typealias AstronautListPresenterProtols = AstronautListPresenterProtocol & AstronautListModuleUserInputProtocol

protocol AstronautListInteractorProtocol: AnyObject {
    func fetchAstronauts()
    func sortAstronautsByName(astronauts: [Astronaut])
}

protocol AstronautListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFetchAstronauts(astronauts: [Astronaut])
    func didFailToFetchAstronauts(error: Error)
}


protocol AstronautListViewProtocol: AnyObject {
    func displayAstronauts(astronauts: [AatronautCellViewModelProtocol])
    func showError(error: Error)
}

protocol AstronautListModuleUserInputProtocol: AnyObject {
    func didSelectAstronaut(astronaut: AatronautCellViewModelProtocol)
    func userTappedToSortItems(astronautsVM: [AatronautCellViewModelProtocol])
}

protocol AstronautListRouterProtocol {
    static func createModule(coordinator: MasterCoordinator) -> UIViewController
}
