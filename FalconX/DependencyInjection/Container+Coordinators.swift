//
//  Container+Coordinators.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerCoordinators() {
        self.autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        self.autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init)
    }
}
