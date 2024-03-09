//
//  HomeCoordinator.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import UIKit

class HomeCoordinator: BaseCoordinator {
    override func start() {
        let viewController = HomeViewController()
        viewController.delegate = self
        
        self.navigationController.setViewControllers([viewController], animated: true)
        self.activeViewcontrollers.append(viewController)
    }
}

extension HomeCoordinator: HomeDelegate {
    func startGame() {
        let coordinator = AppDelegate.container.resolve(GameCoordinator.self)!
        coordinator.navigationController = self.navigationController
        
        self.start(coordinator: coordinator)
    }
}
