//
//  Container+Services.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerServices() {
        self.autoregister(SessionService.self, initializer: SessionService.init).inObjectScope(.container)
        self.autoregister(NetworkManager.self, initializer: NetworkManager.init).inObjectScope(.container)
        self.autoregister(GameService.self, initializer: GameService.init).inObjectScope(.container)
    }
}
