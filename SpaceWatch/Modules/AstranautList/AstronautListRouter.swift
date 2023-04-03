//
//  AstronautListRouter.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

class AstronautListRouter {
    static func createModule(coordinator: MasterCoordinator) -> UIViewController {
        let viewController = AstronautListViewController()
        let interactor = AstronautListInteractor()
        let presenter = AstronautListPresenter()
        let networkService = AstronautListURLSessionNetworkService()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = coordinator
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.networkService = networkService
        
        return viewController
    }
}
