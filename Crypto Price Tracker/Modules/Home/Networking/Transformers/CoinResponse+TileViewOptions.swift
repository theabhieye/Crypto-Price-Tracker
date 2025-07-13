//
//  CoinResponse+TileViewOptions.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Foundation

extension Array where Element == TileViewOptions {
    init(_ response: CoinResponse) {
        self = response.map { coin in
            TileView.Model(
                id: coin.id,
                name: coin.name,
                symbol: coin.symbol.uppercased(),
                currentPrice: coin.currentPrice,
                imageURL: coin.image,
                isDividerHidden: false
            )
        }
    }
}
