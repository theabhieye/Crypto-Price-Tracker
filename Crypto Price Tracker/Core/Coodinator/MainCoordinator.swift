//
//  MainCoordinator.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//
import UIKit

final class MainCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let viewModelFactory: ViewModelFactory
    private let viewControllerFactory: ViewControllerFactory
    private var cryptoListingCoodinator: CryptoListingCoordinator?
    
    init(window: UIWindow,
         viewModelFactory: ViewModelFactory,
         viewControllerFactory: ViewControllerFactory) {
        self.window = window
        self.viewModelFactory = viewModelFactory
        self.viewControllerFactory = viewControllerFactory
        super.init(navigationController: UINavigationController())
    }
    
    override func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        showCrytoListing()
    }
    
    private func showCrytoListing() {
        cryptoListingCoodinator = CryptoListingCoordinator(
            navigationController: navigationController,
            viewModelFactory: viewModelFactory,
            viewControllerFactory: viewControllerFactory
        )
        add(child: cryptoListingCoodinator!)
        cryptoListingCoodinator?.start()
    }
}
