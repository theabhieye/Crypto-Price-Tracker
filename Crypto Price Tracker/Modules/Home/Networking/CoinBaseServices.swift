//
//  CoinBaseServices.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Foundation
import Combine

protocol CoinBaseServicesProtocol {
    func fetchTopCoins(count: Int,
                       completion: @escaping (Result<CoinResponse, NetworkError>) -> Void)
    func fetchCoinWith(ids: [String],
                       completion: @escaping (Result<CoinPriceResponse, NetworkError>) -> Void)
}

extension CoinBaseServicesProtocol {
    
    var defaultTopCoinCount: Int {
        20
    }
    
    func fetchTopCoins(completion: @escaping (Result<CoinResponse, NetworkError>) -> Void) {
        fetchTopCoins(count: defaultTopCoinCount,
                      completion: completion)
    }
}

final class CoinBaseServices: CoinBaseServicesProtocol {
    func fetchTopCoins(count: Int,
                       completion: @escaping (Result<CoinResponse, NetworkError>) -> Void) {
        let request = HomeNetworking.fetchTopCoins(count: count)
        Networking.shared.request(request, type: CoinResponse.self) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error as? NetworkError ?? .unknownError))
            }
        }
    }
    
    func fetchCoinWith(ids: [String],
                       completion: @escaping (Result<CoinPriceResponse, NetworkError>) -> Void) {
        let request = HomeNetworking.fetchAllCoinWith(ids: ids)
        Networking.shared.request(request, type: CoinPriceResponse.self) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let error):
                completion(.failure(error as? NetworkError ?? .unknownError))
            }
        }

    }

}
