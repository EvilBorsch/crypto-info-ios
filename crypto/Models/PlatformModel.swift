//
//  PlatformModel.swift
//  crypto
//
//  Created by Алексей on 13.12.2020.
//

import Foundation

class PlatformModel: Codable {
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
