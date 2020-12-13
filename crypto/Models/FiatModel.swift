//
//  FiatModel.swift
//  crypto
//
//  Created by Алексей on 13.12.2020.
//

import Foundation

class FiatModel: Codable {
    var id: Int
    var symbol: String
    var name: String
    var sign: String
    var price: Double
    var volume24h: Double
    var lastUpdated: String
    
    enum CodingKeys: String, CodingKey {
        case id = "cmc_id"
        case symbol
        case name
        case sign
        case price
        case volume24h = "volume_24h"
        case lastUpdated = "last_updated"
    }
}
