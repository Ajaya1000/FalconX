//
//  GameViewModel.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation

protocol GameViewModelOutput: AnyObject {
    func hasNext() -> Bool
    func hasPrev() -> Bool
    func moveToNext()
    func moveToPrev()
    func didFinish()
    
    func loadData( _ clsr: @escaping (Error?, Error?, Error?) -> Void)
}

class GameViewModel {
    // MARK: - Constants
    let totalDestinationCount: Int = 4
    
    // MARK: - Public Properties
    var selectedIndex = 0
    
    // MARK: - Private Properties
    private var planetsData: [Planet]?
    private var vehiclesData: [Vehicle]?
    
    // MARK: - Dependencies
    private let sessionService: SessionService
    private let networkManager: NetworkManager
    private let gameService: GameService
    
    // MARK: - Initializer
    init(gameService: GameService, sessionService: SessionService, networkManager: NetworkManager) {
        self.gameService = gameService
        self.sessionService = sessionService
        self.networkManager = networkManager
    }
    
    deinit {
        debugPrint("DEBUG: deinit GameViewModel")
    }
}

private extension GameViewModel {
    func loadSessionData(_ completion: @escaping (Error?) -> Void) {
        sessionService.loadSession(completion)
    }
    
    func loadPlanetData(_ completion: @escaping (Error?) -> Void) {
        gameService.loadPlanetsData { [weak self] res in
            guard let self else {
                completion(FXError.unknownError)
                return
            }
            
            switch res {
            case .success(let planetsData):
                self.planetsData = planetsData
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func loadVehiclesData( _ completion: @escaping (Error?) -> Void) {
        gameService.loadVehiclesData { [weak self] res in
            guard let self else {
                completion(FXError.unknownError)
                return
            }
            
            switch res {
            case .success(let vehiclesdata):
                self.vehiclesData = vehiclesdata
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

extension GameViewModel: GameViewModelOutput {
    func hasNext() -> Bool {
        return selectedIndex < totalDestinationCount - 1
    }
    
    func hasPrev() -> Bool {
        return selectedIndex > 0
    }
    
    func moveToNext() {
        guard hasNext() else { return }
        selectedIndex += 1
    }
    
    func moveToPrev() {
        guard hasPrev() else { return }
        selectedIndex -= 1
    }
    
    func didFinish() {}
    
    /// Loads all the data
    /// - Parameter completion: takes two params, 1st being the error from loading plants and 2nd being the error from loading vehicle
    func loadData( _ completion: @escaping (Error?, Error?, Error?) -> Void) {
        let group = DispatchGroup()
        
        var sessionLoadingError: Error?
        var planetDataLoadingError: Error?
        var vehicleDataLoadingError: Error?
        
        // start loading session data
        group.enter()
        loadSessionData { error in
            sessionLoadingError = error
            group.leave()
        }
        
        // Start loading planets
        group.enter()
        loadPlanetData { error in
            planetDataLoadingError = error
            group.leave()
        }
        
        // Start loading vehicles
        group.enter()
        loadVehiclesData { error in
            vehicleDataLoadingError = error
            group.leave()
        }
        
        // notify completion in main thread
        group.notify(queue: .main) {
            completion(sessionLoadingError, planetDataLoadingError, vehicleDataLoadingError)
        }
    }
}
