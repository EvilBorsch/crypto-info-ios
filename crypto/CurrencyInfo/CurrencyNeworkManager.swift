//
//  CurrencyNeworkManager.swift
//  crypto
//
//  Created by Алексей on 23.11.2020.
//

import Alamofire
import Foundation

protocol CurrNetProto: AnyObject {
    func GetCryptoByName(name: String, completion: @escaping (CurrencyModel?) -> Void)
}

final class CurrencyNetworkManager: CurrNetProto {
    private let baseUrl = "http://localhost:5000/api/currency"
    
    func GetCryptoByName(name: String, completion: @escaping (CurrencyModel?) -> Void) {
        AF.request("\(self.baseUrl)/get?curr_name=\(name)").responseJSON {response in
                switch response.result {
                case .success:
                    if let jsonData = response.data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let model = try jsonDecoder.decode(CurrencyModel.self, from: jsonData)
                            completion(model)
                            return
        
                        } catch let error {
                            debugPrint(error.localizedDescription)
                            completion(nil)
                            return
                        }
        
                    }
                case .failure(let error):
                    debugPrint(error)
                    completion(nil)
                    return
                }
            }
    }
    
    static let shared: CurrNetProto = CurrencyNetworkManager()
    
    private init() {}
}
