//
//  CurrencyModel.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import Foundation

class Fiats: Codable {
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

class CurrCryptoInfo: Codable {
    var id: Int
    var maxSupply: Double
    var circulatingSupply: Double
    var totalSupply: Double
    var lastUpdated: String
    var percentChange1h: Double
    var percentChange24h: Double
    var percentChange7d: Double
    var costInFiats: Array<Fiats>
    
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

class Platform: Codable {
    var id: Int
    var name: String
    var symbol: String
    var tokenAddress: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case tokenAddress = "token_address"
    }
}

class Urls: Codable {
    var website: String
    var doc: String
    var twitter: String
    var reddit: String
    var sourceCode: String
    
    enum CodingKeys: String, CodingKey {
        case website
        case doc = "technical_doc"
        case twitter
        case reddit
        case sourceCode = "source_code"
    }
}

class CurrencyModel: Codable {
    var id: Int
    var name: String
    var symbol: String
    var rank: Int
    var logo: String
    var description: String
    var platform: Platform
    var urls: Urls
    var currCryptoInfo: CurrCryptoInfo
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case rank
        case logo
        case description
        case platform
        case urls
        case currCryptoInfo = "curr_crypto_info"
    }
    
}




