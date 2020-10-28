//
//  CurrencyModel.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import Foundation

func getCurrByName(name: String) -> CurrencyModel {
    return CurrencyModel(currencyName: "Bitcoin",
                         stockName: "BTC",
                         cost: 38358.3,
                         convertionCurrnecyName: "USD",
                         didGrow: true,
                         changeValueInPercents: 3.64,
                         description: "bitcoin info")
}

class CurrencyModel {
    var currencyName: String
    var stockName: String
    var cost: Double
    var convertionCurrnecyName: String
    var didGrow: Bool
    var changeValueInPercents: Double
    var description: String
    // Graph must be init here
    init(currencyName: String,
         stockName: String,
         cost: Double,
         convertionCurrnecyName: String,
         didGrow: Bool,
         changeValueInPercents: Double,
         description: String)
    {
        self.currencyName = currencyName
        self.stockName = stockName
        self.cost = cost
        self.convertionCurrnecyName = convertionCurrnecyName
        self.didGrow = didGrow
        self.changeValueInPercents = changeValueInPercents
        self.description = description
    }
    
}

