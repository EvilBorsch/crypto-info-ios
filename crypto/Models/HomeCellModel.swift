//
//  HomeCellModel.swift
//  crypto
//
//  Created by Алексей on 13.12.2020.
//

import Foundation



struct HomeCellModel: Codable {
    var id: Int
    var name: String
    var symbol: String
    var logo: String
    var category: String
    var lastUpdated: String
    var percentChange1h: Double
    var percentChange24h: Double
    var percentChange7d: Double
    var cost: Array<FiatModel>
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case logo
        case category
        case cost
        case lastUpdated = "last_updated"
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
    }
    
    var logoURL:URL? {
        URL(string: logo)
    }
}
