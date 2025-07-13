//
//  SceneSetup.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import UIKit

final class SceneSetup {
    static func createMainCoordinator(windowScene: UIWindowScene) -> (UIWindow, MainCoordinator) {
        let window = UIWindow(windowScene: windowScene)
        let viewModelFactory = DefaultViewModelFactory()
        let viewControllerFactory = DefaultViewControllerFactory()

        let mainCoordinator = MainCoordinator(window: window,
                                              viewModelFactory: viewModelFactory,
                                              viewControllerFactory: viewControllerFactory)
        return (window, mainCoordinator)
    }
}
