//
//  CurrCryptoInfoModel.swift
//  crypto
//
//  Created by Алексей on 13.12.2020.
//

import Foundation

class CurrCryptoInfo: Codable {
    var id: Int
    var maxSupply: Double
    var circulatingSupply: Double
    var totalSupply: Double
    var lastUpdated: String
    var percentChange1h: Double
    var percentChange24h: Double
    var percentChange7d: Double
    var costInFiats: Array<FiatModel>
    
    enum CodingKeys: String, CodingKey {
        case id
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case lastUpdated = "last_updated"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case costInFiats = "cost_in_fiats"
    }
}
