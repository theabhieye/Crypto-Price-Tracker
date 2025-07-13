//
//  DefaultViewControllerFactory.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import UIKit

protocol ViewControllerFactory: AnyObject {
    func getCrytoListingViewController(_ viewModel: CryptoListingViewModel) -> UIViewController
}

final class DefaultViewControllerFactory: ViewControllerFactory {
    func getCrytoListingViewController(_ viewModel: CryptoListingViewModel) -> UIViewController {
        let view = CryptoListingView(viewModel: viewModel)
        return CrytoListingViewController(rootView: view)
    }
}
