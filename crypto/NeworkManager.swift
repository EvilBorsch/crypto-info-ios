//
//  NeworkManager.swift
//  crypto
//
//  Created by Алексей on 23.11.2020.
//

import Alamofire
import Foundation

enum NetError: Error {
    case decodeError
    case requestFailure
    case noDataInRequest
    
    var errorDescription: String {
        switch self {
        case .decodeError:
            return "Decode error"
        case .requestFailure:
            return "Request failure"
        case .noDataInRequest:
            return "No data in request"
        }
    }
}

protocol CurrNetProto: AnyObject {
    func GetCryptoByName(name: String, completion: @escaping (Result<CurrencyModel, Error>) -> Void)
    func GetCryptoListAll(completion: @escaping (Result<[HomeCellModel], Error>) -> Void)
}

final class NetworkManager: CurrNetProto {
    
    private let baseUrl = "\(BASE_URL)/api/currency"
    static let shared: CurrNetProto = NetworkManager()
    private init() {}
    
    func GetCryptoByName(name: String, completion: @escaping (Result<CurrencyModel, Error>) -> Void) {
        AF.request("\(self.baseUrl)/get?curr_name=\(name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)").responseJSON {response in
            switch response.result {
            case .success:
                guard let data = response.data, !data.isEmpty else {
                    completion(.failure(NetError.noDataInRequest))
                    return
                }
                let jsonDecoder = JSONDecoder()
                do {
                    let model = try jsonDecoder.decode(CurrencyModel.self, from: data)
                    completion(.success(model))
                    return
                    
                } catch let error {
                    debugPrint(error.localizedDescription)
                    completion(.failure(NetError.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                completion(.failure(NetError.requestFailure))
                return
            }
        }
    }
    
    func GetCryptoListAll(completion: @escaping (Result<[HomeCellModel], Error>) -> Void) {
        let urlString = baseUrl + "/list"
        
        AF.request(urlString).responseJSON(completionHandler: {response in
            switch response.result{
            case .success:
                guard let data = response.data, !data.isEmpty else {
                    completion(.failure(NetError.noDataInRequest))
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let info = try decoder.decode([HomeCellModel].self, from: data)
                    completion(.success(info))
                    return
                } catch {
                    completion(.failure(NetError.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                completion(.failure(NetError.requestFailure))
                return
            }
        })
    }
}
