//
//  AstronautDetailsProtocols.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit


protocol AstronautDetailsPresenterProtocol: AnyObject {
    func fetchAstronautDetail(astronautId: String)
    func viewDidLoad()
    func didFetchAstronautDetail(astronautDetail: AstronautDetails)
    func didFailToFetchAstronautDetail(error: Error)
}

protocol AstronautDetailsInteractorProtocol: AnyObject {
    var astronautId: Int { get set }
    func fetchAstranaut()
}

protocol AstronautDetailsViewProtocol: AnyObject {
    func displayAstronautDetail(astronautDetails: AstronautDetailsViewModelProtocol)
    func showError(error: Error)
}

protocol AstronautDetailsRouterProtocol: AnyObject {
    static func createModule(astronautId: Int) -> UIViewController
}
