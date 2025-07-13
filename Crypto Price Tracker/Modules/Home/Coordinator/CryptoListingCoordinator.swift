//
//  CryptoListingCoordinator.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import UIKit

final class CryptoListingCoordinator: BaseCoordinator {
    private let viewModelFactory: ViewModelFactory
    private let viewControllerFactory: ViewControllerFactory
    private let coinBaseClient: CoinBaseServicesProtocol
    private var viewModel: CryptoListingViewModel?
    
    private var autoRefreshTimer: Timer?
    private let refreshInterval: TimeInterval = 60
    
    init(navigationController: UINavigationController,
         viewModelFactory: ViewModelFactory,
         viewControllerFactory: ViewControllerFactory,
         coinBaseClient: CoinBaseServicesProtocol = CoinBaseServices()) {
        self.viewModelFactory = viewModelFactory
        self.viewControllerFactory = viewControllerFactory
        self.coinBaseClient = coinBaseClient
        super.init(navigationController: navigationController)
    }
    
    override func start() {
        viewModel = viewModelFactory.getCrytoListingViewModel(delegate: self)
        let viewController = viewControllerFactory.getCrytoListingViewController(viewModel!)
        navigationController.isNavigationBarHidden = true
        navigationController.setViewControllers([viewController], animated: true)
        super.start()
    }
}

extension CryptoListingCoordinator {
    private func startAutoRefresh() {
        stopAutoRefresh()
        autoRefreshTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.viewModel?.navigationInfo?.setLoadingIndicator(as: true)
            }
            
            self.fetchTopCoins()
        }
        
        RunLoop.main.add(autoRefreshTimer!, forMode: .common)
    }

    private func stopAutoRefresh() {
        autoRefreshTimer?.invalidate()
        autoRefreshTimer = nil
    }

}
 
extension CryptoListingCoordinator: CryptoListingViewModelDelegates {
    func onSelectedTop20() {
        fetchTopCoins()
    }
    
    func onViewAppear() {
        if let viewModel = viewModel,
           let selectedOption = viewModel.selectedWatchListOption {
            switch selectedOption {
            case .top20:
                fetchTopCoins()
                startAutoRefresh()
            case .userGenerated(let ids):
                stopAutoRefresh()
            }
        }
    }
    
    private func fetchTopCoins() {
        coinBaseClient.fetchTopCoins {[weak self]  result in
            if let self {
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.viewModel?.updateCoinListing(with: response)
                        self.viewModel?.navigationInfo?.setLoadingIndicator(as: false)
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.viewModel?.showErrorView(with: error)
                    }
                }
            }
        }
        
    }
    
    func onClickAddNewWatchList() {
        viewModel?.showInputWatchListAlert = true
    }
    
    func onClickEditWatchlist() {
        print("TODO: onClickEditWatchlist")
    }
    
    func onClickRefresh() {
        fetchTopCoins()
    }
}
