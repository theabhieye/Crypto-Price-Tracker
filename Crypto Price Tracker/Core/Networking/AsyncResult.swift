//
//  AsyncResult.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

enum AsyncResult<T: Equatable> {
    case loading
    case loaded(T)
    case error(NetworkError)
}
