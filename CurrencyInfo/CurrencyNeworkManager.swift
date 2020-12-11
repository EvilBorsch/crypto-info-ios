//
//  CurrencyNeworkManager.swift
//  crypto
//
//  Created by Алексей on 23.11.2020.
//

import Alamofire
import Foundation

protocol CurrNetProto: AnyObject {
    func GetCryptoByName(name: String, completion: @escaping (CurrencyModel?, String?) -> Void)
}

final class CurrencyNetworkManager: CurrNetProto {
    private let baseUrl = "\(BASE_URL)/api/currency"
    
    func GetCryptoByName(name: String, completion: @escaping (CurrencyModel?, String?) -> Void) {
        AF.request("\(self.baseUrl)/get?curr_name=\(name)").responseJSON {response in
                switch response.result {
                case .success:
                    if let jsonData = response.data {
                        let jsonDecoder = JSONDecoder()
                        do {
                            let model = try jsonDecoder.decode(CurrencyModel.self, from: jsonData)
                            completion(model, nil)
                            return
        
                        } catch let error {
                            debugPrint(error.localizedDescription)
                            let dataString = String(data: jsonData, encoding: .utf8) ?? ""
                            completion(nil, "Decode error: \(error.localizedDescription)\n Server sent: \(dataString)")
                            return
                        }
        
                    }
                case .failure(let error):
                    debugPrint(error)
                    completion(nil, "Request failure: \(error.errorDescription ?? "")")
                    return
                }
            }
    }
    
    static let shared: CurrNetProto = CurrencyNetworkManager()
    
    private init() {}
}
