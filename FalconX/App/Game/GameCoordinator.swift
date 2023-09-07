//
//  GameCoordinator.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation

class GameCoordinator: BaseCoordinator {
    private let sessionService: SessionService
    private let viewModel: GameViewModel
    
    init(sessionService: SessionService, viewModel: GameViewModel) {
        self.sessionService = sessionService
        self.viewModel = viewModel
    }
    
    override func start() {
        startGame()
    }
}

private extension GameCoordinator {
    func startGame() {
        self.removeChildCoordinators()
        
        let viewController = GameViewController(viewModel: self.viewModel)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
