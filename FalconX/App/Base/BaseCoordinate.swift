//
//  BaseCoordinate.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var activeViewcontrollers: [UIViewController] { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start()
    func start(coordinator: Coordinator)
    func didFinish(coordinator: Coordinator)
    func removeChildCoordinators()
}

class BaseCoordinator: Coordinator {
    var activeViewcontrollers: [UIViewController] = []
    
    var childCoordinators: [Coordinator] = []
    
    var navigationController = UINavigationController()
    weak var parentCoordinator: Coordinator?
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(coordinator: Coordinator) {
        self.childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func didFinish(coordinator: Coordinator) {
        guard let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) else {
            return
        }
        
        coordinator.removeChildCoordinators()
        self.childCoordinators.remove(at: index)
    }
    
    func removeChildCoordinators() {
        self.childCoordinators.forEach { didFinish(coordinator: $0) }
        let viewControllers = navigationController.viewControllers.filter({!self.activeViewcontrollers.contains($0)})
        self.navigationController.setViewControllers(viewControllers, animated: false)
    }
}
