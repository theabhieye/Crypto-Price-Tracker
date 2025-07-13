//
//  CryptoTitleView.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import SwiftUI

typealias TileViewOptions = TileView.Model

struct TileView: View {
    struct Model: Equatable, Identifiable {
        var id: String?
        var name: String?
        var symbol: String?
        var currentPrice: Double?
        var imageURL: String?
        var isDividerHidden: Bool?
    }

    var model: Model?

    var body: some View {
        VStack(spacing: Constants.vStackSpacing) {
            if let model = model {
                contentView(model: model)
            }
            dividerView(isHidden: model?.isDividerHidden ?? true)
        }
    }

    // MARK: - Private computed views
    private func contentView(model: Model) -> some View {
        HStack {
            imageView(urlString: model.imageURL)
            titleView(name: model.name, symbol: model.symbol)
            Spacer()
            priceView(price: model.currentPrice)
        }
        .padding(.vertical, Constants.contentVerticalPadding)
        .padding(.horizontal)
    }

    private func imageView(urlString: String?) -> some View {
        CachedAsyncImage(url: URL(string: urlString ?? ""))
            .frame(width: Constants.imageSize, height: Constants.imageSize)
            .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
    }

    private func titleView(name: String?, symbol: String?) -> some View {
        VStack(alignment: .leading, spacing: Constants.titleSpacing) {
            Text(name ?? "")
                .font(.headline)
                .lineLimit(1)
            Text(symbol?.uppercased() ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    private func priceView(price: Double?) -> some View {
        Group {
            if let price = price {
                Text("$\(String(format: "%.3f", price))")
                    .font(.body)
                    .foregroundColor(.green)
            } else {
                RoundedRectangle(cornerRadius: Constants.priceCornerRadius)
                    .fill(Color.blue)
                    .frame(width: Constants.pricePlaceholderWidth, height: Constants.pricePlaceholderHeight)
            }
        }
    }


    private func dividerView(isHidden: Bool) -> some View {
        Group {
            if !isHidden {
                Divider()
                    .padding(.leading, Constants.dividerLeadingPadding)
            }
        }
    }

    // MARK: - Constants
    private enum Constants {
        static let vStackSpacing: CGFloat = 0
        static let contentVerticalPadding: CGFloat = 8
        static let imageSize: CGFloat = 30
        static let imageCornerRadius: CGFloat = 5
        static let titleSpacing: CGFloat = 2
        static let priceCornerRadius: CGFloat = 25
        static let pricePlaceholderWidth: CGFloat = 40
        static let pricePlaceholderHeight: CGFloat = 15
        static let dividerLeadingPadding: CGFloat = 70
    }
}
