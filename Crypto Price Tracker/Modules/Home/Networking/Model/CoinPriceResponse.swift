//
//  CoinPriceResponse.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

typealias CoinPriceResponse = [String: CoinPrice]

struct CoinPrice: Decodable {
    let usd: Double
}
