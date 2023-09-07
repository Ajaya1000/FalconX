//
//  SessionService.swift
//  FalconX
//
//  Created by Ajaya Mati on 06/09/23.
//

import Foundation

class SessionService {
    //MARK: - Dependencies
    private let networkManager: NetworkManager
    
    // MARK: - Properties
    var session: Session?
    
    // MARK: - Initializer
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
}

// MARK: - Public Methods
extension SessionService {
    func loadSession( _ completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: APIEndPoints.token) else {
            completion(FXError.invalidURLString)
            return
        }
        
        let headers: [String: String] = ["Accept": "application/json"]
        
        networkManager.request(url: url, httMethod: .post, httpHeaders: headers) { [weak self] (res: Result<Session, Error>) in
            guard let self else {
                completion(FXError.unknownError)
                return
            }
            
            switch res {
            case .success(let sessionData):
                self.session = sessionData
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
}

extension SessionService {
    enum SessionError: Error {
        case invalidToken
    }
}
