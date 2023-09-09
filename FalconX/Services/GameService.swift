//
//  GameService.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import Foundation

class GameService {
    // MARK: - Dependencies
    private let sessionService: SessionService
    private let networkManager: NetworkManager
    
    init(sessionService: SessionService, networkManager: NetworkManager) {
        self.sessionService = sessionService
        self.networkManager = networkManager
    }
}

extension GameService {
    func loadPlanetsData(_ completion: @escaping (Result<[Planet], Error>) -> Void) {
        guard let url = URL(string: APIEndPoints.planets) else {
            completion(.failure(FXError.invalidURLString))
            return
        }
        
        networkManager.request(url: url, completion: completion)
    }
    
    func loadVehiclesData(_ completion: @escaping (Result<[Vehicle], Error>) -> Void) {
        guard let url = URL(string: APIEndPoints.vehicles) else {
            completion(.failure(FXError.invalidURLString))
            return
        }
        
        networkManager.request(url: url, completion: completion)
    }
    
    func submit(planets: [Planet], vehicles: [Vehicle],_ completion: @escaping (Result<FindPlanetResponse, Error>) -> Void ) {
        guard let url = URL(string: APIEndPoints.find) else {
            completion(.failure(FXError.invalidURLString))
            return
        }
        
        guard let token = sessionService.session?.token else {
            completion(.failure(SessionService.SessionError.invalidToken))
            return
        }
        
        let planetNames = planets.compactMap {$0.name}
        let vehcileNames = vehicles.compactMap({$0.name})
        
        let headers: [String: String] = ["Accept": "application/json", "Content-Type": "application/json"]
        
        let requestBody = FindPlanetRequest(token: token, planetNames: planetNames, vehicleNames: vehcileNames)
        
        networkManager.request(url: url, httMethod: .post, httpHeaders: headers, httpBody: requestBody, completion: completion)
    }
}

enum GameServiceError: String, Error {
    case errorInSubmit
}
