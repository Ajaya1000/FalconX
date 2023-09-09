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
    
    deinit {
        debugPrint("DEBUG: deinit GameCoordinator")
    }
}

private extension GameCoordinator {
    func startGame() {
        showLoadingScreen()
        loadGameData()
    }
    
    func loadGameData() {
        viewModel.loadData { [weak self] sessionError, planetError, vehicleError in
            guard let self else { return }
            // debug errors
            debugPrint(sessionError)
            debugPrint(planetError)
            debugPrint(vehicleError)
            
            guard sessionError == nil,
                  planetError == nil,
                  vehicleError == nil else {
                
                let alert: AlertActionItem = .action(title: DisplayString.okay, handler: { [weak self] _ in
                    guard let self else { return }
                        self.navigationController.popViewController(animated: true)
                        self.parentCoordinator?.didFinish(coordinator: self)
                })
                
                let description = (sessionError != nil) ? DisplayString.errorLoadingSession : DisplayString.errrorLoadingGameData
                
                self.navigationController.topViewController?.showAlertController(with: description, alerts: [alert])
                return
            }
            
            DispatchQueue.main.async {
                self.showGame()
            }
        }
    }
    
    func showLoadingScreen() {
        self.removeChildCoordinators()
        
        let viewController = GameLoaderViewController()
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func showGame() {
        self.removeChildCoordinators()
        
        let viewController = GameViewController(viewModel: self.viewModel, delegate: self)
        self.navigationController.replaceTop(with: viewController, fade: false)
    }
    
    func showResult() {
        self.removeChildCoordinators()
        
        let viewController = ResultViewController(viewModel: self.viewModel, delegate: self)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - GameViewControllerDelegate
extension GameCoordinator: GameViewControllerDelegate {
    func submitSelections() {
        showResult()
    }
}

//MARK: - ResultViewControllerDelegate
extension GameCoordinator: ResultViewControllerDelegate {
    func startOver() {
        viewModel.reset()
        startGame()
    }
}
