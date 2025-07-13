//
//  CoinResponse.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

struct CoinResponseElement: Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
    }
}

typealias CoinResponse = [CoinResponseElement]
