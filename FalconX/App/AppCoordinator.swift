//
//  AppCoordinator.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    var window = UIWindow(frame: UIScreen.main.bounds)
    
    override func start() {
        showHome()
        window.makeKeyAndVisible()
    }
}

private extension AppCoordinator {
    func showHome() {
        self.removeChildCoordinators()
        
        let homeCoordinator = AppDelegate.container.resolve(HomeCoordinator.self)!
        homeCoordinator.navigationController = BaseNavigationController()
        
        self.start(coordinator: homeCoordinator)
        
        window.rootViewController = homeCoordinator.navigationController
    }
}
