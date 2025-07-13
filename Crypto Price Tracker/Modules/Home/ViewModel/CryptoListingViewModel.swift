//
//  CryptoListingViewModel.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import SwiftUI

typealias CryptoListingViewModelDelegates = CryptoListingViewModelDelegate &
                                            CryptoNavigationBarDelegate
                        
protocol CryptoListingViewModelDelegate: AnyObject {
    func onClickAddNewWatchList()
    func onViewAppear()
    func onSelectedTop20()
}

final class CryptoListingViewModel: ObservableObject {
    @Published var showInputWatchListAlert: Bool = false
    @Published var watchlistName: String
    @Published var selectedWatchListOption: SelectedWatchListOption?
    weak var delegate: CryptoListingViewModelDelegates?
    @Published var navigationInfo: CryptoNavigationBarInfo? = nil
    var watchListMenuOptions: ActionMenuOptions? = nil
    @Published var crytoListingData: AsyncResult<[TileViewOptions]>
    
    init(showInputWatchListAlert: Bool = false,
         watchlistName: String = "",
         selectedWatchListOption: SelectedWatchListOption,
         navigationInfo: CryptoNavigationBarInfo? = nil,
         watchListMenu: ActionMenuOptions? = nil,
         delegate: CryptoListingViewModelDelegates? = nil,
         watchListMenuOptions: ActionMenuOptions? = nil,
         crytoListingData: AsyncResult<[TileViewOptions]>
    ) {
        self.showInputWatchListAlert = showInputWatchListAlert
        self.watchlistName = watchlistName
        self.navigationInfo = navigationInfo
        self.selectedWatchListOption = selectedWatchListOption
        self.delegate = delegate
        self.watchListMenuOptions = watchListMenuOptions
        self.crytoListingData = crytoListingData
    }
}

extension CryptoListingViewModel {
    func onViewAppear() {
        if let delegate {
            delegate.onViewAppear()
        }
    }
    
    func retry() {
        onViewAppear()
    }
    
    func createWatchlist(named name: String) {
        print("Created watchlist: \(name)")
    }
}
