//
//  NetworkingService.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Combine
import Foundation

protocol NetworkingService {
    func request<T: Decodable>(
        _ request: NetworkingRequestType,
        type: T.Type,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy,
        completion: @escaping(Result<T, Error>) -> Void
    )
}

final class Networking: NetworkingService {
    
    static let shared: Networking = Networking()
    
    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }
    
    private var session: URLSession {
        URLSession.shared
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private init() { }
    
    func request<T: Decodable>(
        _ request: NetworkingRequestType,
        type: T.Type,
        decodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        if !Reachability.isConnectedToNetwork() {
            NetworkLogger.logRequest(
                request,
                response: nil,
                responseType: type,
                data: nil,
                error: NetworkError.noInternet,
                duration: 0
            )
            completion(.failure(NetworkError.noInternet))
            return
        }

        decoder.keyDecodingStrategy = decodingStrategy

        var networkRequest: URLRequest?
        let startTime = Date()
        var capturedResponse: URLResponse? = nil
        var capturedData: Data? = nil

        do {
            networkRequest = try request.asURLRequest()
        } catch {
            NetworkLogger.logRequest(
                request,
                response: nil,
                responseType: type,
                data: nil,
                error: NetworkError.badRequest,
                duration: 0
            )
            return completion(.failure(NetworkError.badRequest))
        }

        URLSession.shared.dataTaskPublisher(for: networkRequest!)
            .handleEvents(receiveOutput: { output in
                capturedResponse = output.response
                capturedData = output.data
            })
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw NetworkError.unknownError
                }
                if response.statusCode > 399 {
                    throw self.httpError(response.statusCode)
                }
                return output.data
            }
            .decode(type: type, decoder: decoder)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { completionResponse in
                let duration = Date().timeIntervalSince(startTime)
                switch completionResponse {
                case .finished:
                    break
                case .failure(let error):
                    NetworkLogger.logRequest(
                        request,
                        response: capturedResponse,
                        responseType: type,
                        data: capturedData,
                        error: self.handleError(error),
                        duration: duration
                    )
                    completion(.failure(self.handleError(error)))
                }
            }, receiveValue: { data in
                let duration = Date().timeIntervalSince(startTime)
                NetworkLogger.logRequest(
                    request,
                    response: capturedResponse,
                    responseType: type,
                    data: capturedData,
                    error: nil,
                    duration: duration
                )
                completion(.success(data))
            })
            .store(in: &self.cancellableSet)
    }

    
    private func httpError(_ statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            if let decodingError = error as? DecodingError {
                print(">>>>>>>> \(decodingError)")
                return .decodableFailure(decodingError)
            }
            return .decodableFailure(error)
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkError:
            return error
        default:
            return .unknownError
        }
    }
}
