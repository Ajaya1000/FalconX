//
//  FindPlanetRequest.swift
//  FalconX
//
//  Created by Ajaya Mati on 09/09/23.
//

import Foundation

struct FindPlanetRequest: Encodable {
    var token: String
    var planetNames: [String]
    var vehicleNames: [String]
    
    private enum CodingKeys: String, CodingKey {
        case token
        case planetNames = "planet_names"
        case vehicleNames = "vehicle_names"
    }
}
