//
//  CurrencyModel.swift
//  crypto
//
//  Created by Алексей on 28.10.2020.
//

import Foundation

class CurrencyModel: Codable {
    var currencyName: String
    var stockName: String
    var cost: Double
    var convertionCurrencyName: String
    var didGrow: Bool
    var changeValueInPercents: Double
    var description: String
    
    init(currencyName: String,
         stockName: String,
         cost: Double,
         convertionCurrencyName: String,
         didGrow: Bool,
         changeValueInPercents: Double,
         description: String)
    {
        self.currencyName = currencyName
        self.stockName = stockName
        self.cost = cost
        self.convertionCurrencyName = convertionCurrencyName
        self.didGrow = didGrow
        self.changeValueInPercents = changeValueInPercents
        self.description = description
    }
    
    init() {
        self.currencyName = "Загрузка..."
        self.stockName = "Загрузка..."
        self.cost = 0
        self.convertionCurrencyName = "Загрузка..."
        self.didGrow = false
        self.changeValueInPercents = 0
        self.description = "Загрузка..."
    }
    
}




