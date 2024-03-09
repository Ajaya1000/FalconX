//
//  GameViewModel.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation

protocol GameViewModelOutput: AnyObject {
    func canMovePrev() -> Bool
    func canMoveNext() -> Bool
    func isLast() -> Bool
    func moveToNext()
    func moveToPrev()
    
    func loadData(_ completion: @escaping (Error?, Error?, Error?) -> Void)
    func submit(_ completion: @escaping (Error?) -> Void)
    
    func getCurrentPlanet() -> Planet?
    func getCurrentVehicle() -> Vehicle?
    
    func getFoundPlanetName() -> String?
    
    var timeTaken: Int { get }
    
    var selectedIndex: Int { get }
    var availablePlanets: [Planet] { get }
    var availableVehicles: [Vehicle] { get }
}

protocol GameViewModelInput: AnyObject {
    func didSelectPlanet(at index: Int)
    func didSelectVehicle(at index: Int)
    func reset()
}

class GameViewModel {
    // MARK: - Constants
    let numberOfComponents: Int = 1
    let totalDestinationCount: Int = 4
    
    // MARK: - Public Properties
    private(set) var selectedIndex: Int = 0
    
    // MARK: - Private Properties
    private var selectedPlantes: [Planet?] = []
    private var selectedVehicles: [Vehicle?] = []
    private var planetsData: [Planet]?
    private var vehiclesData: [Vehicle]?

    // reponse
    private var result: FindPlanetResponse? = nil
    
    // MARK: - Computed properties
    var availablePlanets: [Planet] {
        var _availablePlantes = planetsData ?? []
        
        // remove already selected planets
        selectedPlantes.compactMap({$0}).forEach({ _availablePlantes.remove($0)})
        
        return _availablePlantes
    }
    
    var availableVehicles: [Vehicle] {
        var availableVehicles = vehiclesData ?? []
        
        // reduce count for already selected vehicles
        selectedVehicles.compactMap({$0}).forEach({ selectedVehicle in
            if let index = availableVehicles.firstIndex(where: {$0.name == selectedVehicle.name}) {
                availableVehicles[index].count = (availableVehicles[index].count ?? 0) - 1
            }
        })
        
        // remove the vehicles where count is zero
        availableVehicles = availableVehicles.filter({($0.count ?? 0) > 0})
        
        return availableVehicles
    }
    
    // MARK: - Dependencies
    private let sessionService: SessionService
    private let networkManager: NetworkManager
    private let gameService: GameService
    
    // MARK: - Initializer
    init(gameService: GameService, sessionService: SessionService, networkManager: NetworkManager) {
        self.gameService = gameService
        self.sessionService = sessionService
        self.networkManager = networkManager
        
        initializeData()
    }
    
    deinit {
        debugPrint("DEBUG: deinit GameViewModel")
    }
}

private extension GameViewModel {
    func initializeData() {
        selectedIndex = 0

        selectedPlantes = .init(repeating: nil, count: totalDestinationCount)
        selectedVehicles = .init(repeating: nil, count: totalDestinationCount)
    }
    
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
    
    func loadVehiclesData(_ completion: @escaping (Error?) -> Void) {
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
    
    func submitUserSelections(_ completion: @escaping (Error?) -> Void) {
        let planets = selectedPlantes.compactMap({$0})
        let vehicles = selectedVehicles.compactMap({$0})
        
        gameService.submit(planets: planets, vehicles: vehicles) { [weak self] res in
            guard let self else {
                completion(FXError.unknownError)
                return
            }
            
            switch res {
            case .success(let data):
                self.result = data
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    func selectPlanet(at index: Int) {
        guard let planet = availablePlanets[safe: index] else { return }
        
        setSelectedPlanet(with: planet)
    }
    
    func selectVehicle(at index: Int) {
        let vehicle = availableVehicles[safe: index]
        
        setSelectedVehicle(with: vehicle)
    }
    
    func setSelectedPlanet(with data: Planet?) {
        self.selectedPlantes[selectedIndex] = data
    }
    
    func setSelectedVehicle(with data: Vehicle?) {
        self.selectedVehicles[selectedIndex] = data
    }
    
    func resetSelectedIndexData() {
        setSelectedPlanet(with: nil)
        setSelectedVehicle(with: nil)
    }
    
    func hasNext() -> Bool {
        return selectedIndex < totalDestinationCount - 1
    }
    
    func hasPrev() -> Bool {
        return selectedIndex > 0
    }
}

extension GameViewModel: GameViewModelInput {
    func didSelectPlanet(at index: Int) {
        selectPlanet(at: index)
    }
    
    func didSelectVehicle(at index: Int) {
        selectVehicle(at: index)
    }
    
    func reset() {
        initializeData()
    }
}

extension GameViewModel: GameViewModelOutput {
    func getCurrentPlanet() -> Planet? {
        selectedPlantes[selectedIndex]
    }
    
    func getCurrentVehicle() -> Vehicle? {
        selectedVehicles[selectedIndex]
    }
    
    func currentSelectionValidity() -> Bool {
        guard getCurrentVehicle() != nil,
              getCurrentPlanet() != nil else { return false }
        
        return true
    }
    
    func canMovePrev() -> Bool {
        return hasPrev()
    }
    
    func canMoveNext() -> Bool {
        return (hasNext() || isLast()) && currentSelectionValidity()
    }
    
    func isLast() -> Bool {
        return selectedIndex == totalDestinationCount - 1
    }
    
    func moveToNext() {
        guard hasNext() else { return }
        selectedIndex += 1
    }
    
    func moveToPrev() {
        guard hasPrev() else { return }
        resetSelectedIndexData()
        selectedIndex -= 1
    }
    
    /// Loads all the data
    /// - Parameter completion: takes two params, 1st being the error from loading plants and 2nd being the error from loading vehicle
    func loadData(_ completion: @escaping (Error?, Error?, Error?) -> Void) {
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
            self.initializeData()
            completion(sessionLoadingError, planetDataLoadingError, vehicleDataLoadingError)
        }
    }
    
    /// Submit user selections
    /// - Parameter completion: completion callback
    func submit(_ completion: @escaping (Error?) -> Void) {
        submitUserSelections { error in
            if let error {
                completion(error)
                return
            }
            
            if self.result?.error != nil {
                completion(GameServiceError.errorInSubmit)
                return
            }
            
            completion(nil)
        }
    }
    
    func getFoundPlanetName() -> String? {
        return result?.planetName
    }
    
    var timeTaken: Int {
        var totalTimeTaken = 0
        
        for i in 0...4 {
            if let distance = selectedPlantes[safe: i]??.distance,
               let speed = selectedVehicles[safe: i]??.speed {
                totalTimeTaken += distance / speed // not considering floating point values
            } else {
                continue
            }
        }
        
        return totalTimeTaken
    }
}
