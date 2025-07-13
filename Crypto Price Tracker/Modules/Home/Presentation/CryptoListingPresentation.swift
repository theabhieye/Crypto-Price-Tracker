//
//  CryptoListingPresentation.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Foundation

extension CryptoListingViewModel {
    convenience init(delegate: CryptoListingViewModelDelegates?) {
        let navigationInfo = CryptoNavigationBarInfo(onClickEditWatchlist: {
            delegate?.onClickEditWatchlist()
        }, onClickRefresh:  {
            delegate?.onClickRefresh()
        })
        
        let watchListMenuOptions = ActionMenuOptions(
            title: ActionMenu.Model.ButtonType.titleWithTrailingIcon(
                title: "Top 20",
                icon: "chevron.up.chevron.down"
            ),
            options: [
                ActionMenu.Model.Options(title: "New Watch List", icon: "plus", shouldShowDivider: true,
                                         action: delegate?.onClickAddNewWatchList),
                ActionMenu.Model.Options(title: "Top 20", action: delegate?.onSelectedTop20),
            ]
        )
        
        let crytoListingData: AsyncResult<[TileViewOptions]> = .loading
        let selectedWatchListOption = SelectedWatchListOption.top20
        self.init(selectedWatchListOption: selectedWatchListOption,
                  navigationInfo: navigationInfo,
                  delegate: delegate,
                  watchListMenuOptions:
                    watchListMenuOptions,
                  crytoListingData: crytoListingData)
    }
    
    func onUpdateSelectedWatchListOption(_ selectedWatchListOption: SelectedWatchListOption) {
        self.selectedWatchListOption = selectedWatchListOption
    }
    
    func updateCoinListing(with coinResponse: CoinResponse) {
        let tiles = [TileViewOptions](coinResponse)
        self.crytoListingData = .loaded(tiles)
    }
    
    func showErrorView(with error: NetworkError) {
        self.crytoListingData = .error(error)
    }
}


extension CryptoNavigationBarInfo {
    init(onClickEditWatchlist: @escaping () -> Void,
         onClickRefresh: @escaping () -> Void) {
        title = "Crypto"
        subtitle = Date().abbreviatedMonthDay
        menuOptions = ActionMenuOptions(
            title: ActionMenuOptions.ButtonType.icon("ellipsis"),
            options: [
                ActionMenuOptions.Options(title: "Edit watchlist",
                      icon: "pencil",
                      action: onClickEditWatchlist
                     ),
                ActionMenuOptions.Options(
                    title: "Refresh",
                    icon: "arrow.clockwise",
                    action: onClickRefresh
                )
            ]
        )
        showLoading = false
    }
     
    mutating func setLoadingIndicator(as flag: Bool) {
        showLoading = flag
    }
}
