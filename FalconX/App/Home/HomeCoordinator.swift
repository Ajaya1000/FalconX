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
        
        self.navigationController.isNavigationBarHidden = true
        self.navigationController.viewControllers = [viewController]
    }
}
