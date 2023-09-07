//
//  Container+RegisterDependencies.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation
import Swinject

extension Container {
    func registerDependencies() {
        registerCoordinators()
        registerServices()
        registerViewModels()
    }
}
