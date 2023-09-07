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
}
