//
//  ViewModelFactory.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

protocol ViewModelFactory: AnyObject {
    func getCrytoListingViewModel(delegate: CryptoListingViewModelDelegates) -> CryptoListingViewModel
}

final class DefaultViewModelFactory: ViewModelFactory {
    func getCrytoListingViewModel(delegate: CryptoListingViewModelDelegates) -> CryptoListingViewModel {
        CryptoListingViewModel(delegate: delegate)
    }
}
