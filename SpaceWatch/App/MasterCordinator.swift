//
//  MasterCordinator.swift
//  SpaceWatch
//
//  Created by Tony Thomas on 1/4/2023.
//

import UIKit


class MasterCoordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func start() {
        let astronautListView = AstronautListRouter.createModule(coordinator: self)
        navigationController.viewControllers = [astronautListView]
    }
    
    func openAstronautDetailModule(astronautId: Int) {
        let astronautDetailModule = AstronautDetailRouter.createModule(astronautId: astronautId)
        navigationController.pushViewController(astronautDetailModule, animated: true)
    }
}
