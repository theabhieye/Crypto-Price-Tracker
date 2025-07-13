//
//  HomeNetworking.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Foundation

// https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1
// https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd
enum HomeNetworking {
    case fetchTopCoins(count: Int)
    case fetchAllCoinWith(ids: [String])
}

extension HomeNetworking: NetworkingRequestType {

    private enum Constant {
        static let currency: (key: String, value: String) = ("vs_currency", "usd")
        static let pageNumber: (key: String, value: String) = ("page", "1")
        static let vsCurrencies: (key: String, value: String) = ("vs_currencies", "usd")
        static let perPage: String = "per_page"
        static let ids = "ids"
    }
    
    var path: String {
        switch self {
        case .fetchTopCoins: return "coins/markets/"
        case .fetchAllCoinWith: return "simple/price/"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchTopCoins, .fetchAllCoinWith: .GET
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .fetchTopCoins: [:]
        case .fetchAllCoinWith: [:]
        }
    }
    
    var queryParam: [String : String]? {
        switch self {
        case .fetchTopCoins(let count):
            [
                Constant.perPage: "\(count)",
                Constant.currency.key: Constant.currency.value,
                Constant.pageNumber.key: Constant.pageNumber.value,
            ]
        case .fetchAllCoinWith(let ids):
            [
                Constant.ids: "\(ids.joined(separator: ","))",
                Constant.vsCurrencies.key: Constant.vsCurrencies.value
            ]
        }
    }
    
    var headers: HTTPHeaders {
        HTTPHeaders()
    }
}

