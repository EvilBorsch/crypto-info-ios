//
//  CurrencyModel.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import Foundation


class CurrencyModel: Codable {
    var id: Int
    var name: String
    var symbol: String
    var rank: Int
    var logo: String
    var description: String
    var platform: PlatformModel
    var urls: UrlsModel
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
    
    var logoURL:URL? {
        URL(string: logo)
    }
    
}




