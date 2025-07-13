//
//  EnvironmentType.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Foundation

enum EnvironmentType {
    case staging
    case production
    
    var environment: Environment {
        switch self {
        case .staging:
            StagingEnvironment()
        case .production:
            ProductionEnvironment()
        }
    }
}

protocol Environment {
    var environment: EnvironmentType { get }
    var baseApiUrl: String { get }
}

private struct StagingEnvironment: Environment {
    var environment: EnvironmentType {
        .staging
    }
    
    // TODO: Config staging URL
    var baseApiUrl: String {
        "https://api.coingecko.com/api/v3/"
    }
}

private struct ProductionEnvironment: Environment {
    var environment: EnvironmentType {
        .production
    }
    
    // TODO: Config production URL
    var baseApiUrl: String {
        "https://api.coingecko.com/api/v3/"
    }
}

class AppEnvironment {
    
    static let shared: AppEnvironment = AppEnvironment()
    
    let environment: Environment
    
    private init() {
        var environmentType: EnvironmentType = .production
        #if DEBUG
        environmentType = .staging
        #endif
        self.environment = environmentType.environment
    }
    
}
