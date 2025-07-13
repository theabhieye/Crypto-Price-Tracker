//
//  CrytoListingViewController.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import SwiftUI
import UIKit

final class CrytoListingViewController: UIHostingController<CryptoListingView> { }

struct CryptoListingView: View {
    
    @StateObject var viewModel: CryptoListingViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                navigationBar
                    .padding()
                ScrollView {
                    contentView
                }
                .onAppear {
                    viewModel.onViewAppear()
                }
            }
            CustomTextFieldAlert(
                isPresented: $viewModel.showInputWatchListAlert,
                text: $viewModel.watchlistName,
                title: "New Watchlist"
            ) { name in
                viewModel.createWatchlist(named: name)
            }
        }
        .animation(.easeInOut, value: viewModel.showInputWatchListAlert)
    }

    private var contentView: some View {
        Group {
            switch viewModel.crytoListingData {
            case .loading:
                ProgressView()
            case .loaded(let crytoListingData):
                coinListingView(crytoListingData: crytoListingData)
            case .error(let error):
                NetworkErrorView(error: error) {
                    viewModel.retry()
                }
            }
        }
    }
    
    private func coinListingView(crytoListingData: [TileViewOptions]) -> some View {
        ScrollView {
            watchlistMenu
                .padding(.horizontal, 4)
            VStack {
                ForEach(crytoListingData) { item in
                    TileView(model: TileViewOptions(
                        name: item.name,
                        symbol: item.symbol,
                        currentPrice: item.currentPrice,
                        imageURL: item.imageURL,
                        isDividerHidden: item.isDividerHidden
                    ))
                }
            }
        }
    }
    
    private var navigationBar: some View {
        CryptoNavigationBar(model: viewModel.navigationInfo)
    }
    
    private var watchlistMenu: some View {
        HStack {
            if let menuOptions = viewModel.watchListMenuOptions {
                ActionMenu(model: menuOptions)
                Spacer()
            }
        }
    }
    
}
