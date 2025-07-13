//
//  Environment.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//


import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

protocol NetworkingRequestType {
    var baseUrl: String { get }
    var path: String { get }
    var fullPath: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var queryParam: [String: String]? { get }
    var headers: HTTPHeaders { get }
}

extension NetworkingRequestType {
    var baseUrl: String {
        guard let apiUrl = URL(string: AppEnvironment.shared.environment.baseApiUrl) else {
            fatalError("API base URL note configured.")
        }
        return apiUrl.absoluteString
    }
    
    var fullPath: String {
        "\(baseUrl)/\(path)"
    }
}

extension NetworkingRequestType {
    func asURLRequest() throws -> URLRequest {
        var requestURL = URL(string: fullPath)!
        
        if path.contains("http") {
            requestURL = try path.asURL()
        } else {
            requestURL = try baseUrl.appending(path).asURL()
        }
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = method.rawValue
        
        headers.forEach({
            request.addValue($0.key, forHTTPHeaderField: $0.value)
        })
        
        if let queryParam, !queryParam.isEmpty {
            request.url?.append(queryItems: queryParam.map {
                return URLQueryItem(name: $0.key, value: $0.value)
            })
        }
        
        if let parameters,
           !parameters.isEmpty {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }
        
        return request
    }
}

private extension String {
    func asURL() throws -> URL {
        guard let url = URL(string: self) else { throw NetworkError.invalidUrl(urlString: self) }
        return url
    }
}

 
