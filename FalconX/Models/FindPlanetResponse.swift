//
//  FindPlanetResponse.swift
//  FalconX
//
//  Created by Ajaya Mati on 09/09/23.
//

import Foundation

struct FindPlanetResponse: Decodable {
    var planetName: String?
    var status: Status?
    var error: String?
    
    private enum CodingKeys: String, CodingKey {
        case planetName = "planet_name"
        case status
        case error
    }
}

extension FindPlanetResponse {
    enum Status: String, Decodable {
        case success
        case failure = "false"
    }
}
