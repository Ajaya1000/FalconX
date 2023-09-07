//
//  Vehicle.swift
//  FalconX
//
//  Created by Ajaya Mati on 07/09/23.
//

import Foundation

struct Vehicle: Decodable {
    var name: String?
    var count: Int?
    var maxDistance: Int?
    var speed: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case count = "total_no"
        case maxDistance = "max_distance"
        case speed
    }
}
