//
//  BaseCoordinator.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 12/07/25.
//

import UIKit

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // to be overridden
    }

    func add(child: Coordinator) {
        childCoordinators.append(child)
    }

    func remove(child: Coordinator) {
        childCoordinators.removeAll {
            return $0 === child
        }
    }

    deinit {
        print("\(type(of: self)) deallocated")
    }
}

#if DEBUG
extension BaseCoordinator {
    var testHooks: TestHooks {
        TestHooks(self)
    }
    
    struct TestHooks {
        let target: BaseCoordinator
        init(_ target: BaseCoordinator) {
            self.target = target
        }
        
        var childCoordinators: [ Coordinator] { target.childCoordinators }
        var navigationController: UINavigationController { target.navigationController }
    }
}
#endif
