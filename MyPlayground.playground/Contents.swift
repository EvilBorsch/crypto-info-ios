//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Alamofire


struct priceData: Codable {
    let open: Double
    let date: String
}

struct Coins: Codable {
    let baseCurrency: String
    let priceData: [priceData]
    let quoteCurrency: String
}


let startDate = "2020-12-10" // related to variable "start"
let token = "6f2a566c0934c31be8a2b584d8270ae100bd8721"
//let symbol = "btc"
//let ticker = symbol + "usd" // it's combination of symbol and requiring currency
let frequency = "1day"





func getXYLastWeek(symbol: String, completion: @escaping (Result<[Coins], Error>) -> Void) {
    let ticker = symbol + "usd"
    let url1 = URL(string:"https://api.tiingo.com/tiingo/crypto/prices?tickers="+ticker+"&startDate="+startDate+"&resampleFreq="+frequency+"&token="+token)!
    
    
    AF.request(url1).responseJSON { response in
     //   print(response)
        switch response.result {
        
        case .success:
            do {
                let prices = try JSONDecoder().decode([Coins].self, from: response.data!)
                completion(.success(prices))
                
              
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
                print(error)
            }

        case let .failure(error):
            print("Request error: \(error.localizedDescription)")
        }
    }
}

var xyPair: [(day: Int, price: Double)] = []

let res = getXYLastWeek(symbol: "btc",completion: {result in
    switch result {
    case .success(let coins):
        var dayOfMonth = 10
       
        for data in coins[0].priceData {
            xyPair.append((day: dayOfMonth, price: data.open))
            dayOfMonth += 1
        }
        print(xyPair)
    case .failure(let error):
        debugPrint(error)
    }
    
})



//print(res)
