//
//  SceneDelegate.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let (window, coordinator) = SceneSetup.createMainCoordinator(windowScene: windowScene)

        self.window = window
        self.mainCoordinator = coordinator
        coordinator.start()
        window.makeKeyAndVisible()

    }
}

