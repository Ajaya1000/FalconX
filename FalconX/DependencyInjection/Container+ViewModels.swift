//
//  Container+ViewModel.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        self.autoregister(GameViewModel.self, initializer: GameViewModel.init)
    }
}
