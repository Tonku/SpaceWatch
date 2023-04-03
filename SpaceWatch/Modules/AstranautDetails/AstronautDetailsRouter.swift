//
//  AstronautDetailsRouter.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit

class AstronautDetailRouter: AstronautDetailsRouterProtocol {
    static func createModule(astronautId: Int) -> UIViewController {
        let storyBoard = UIStoryboard(name: "DetailsStoryBoard", bundle: .main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "AstronautDetailViewController") as! AstronautDetailViewController
        let interactor = AstronautDetailInteractor()
        let presenter = AstronautDetailPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.astronautId = astronautId
        
        return viewController
    }
}
