//
//  NetworkErrorView.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//


import SwiftUI

struct NetworkErrorView: View {
    let error: NetworkError
    let retryAction: (() -> Void)?

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: Constants.errorIcon)
                .resizable()
                .scaledToFit()
                .frame(width: Constants.iconSize, height: Constants.iconSize)
                .foregroundColor(.red)

            Text(errorMessage)
                .multilineTextAlignment(.center)
                .font(.headline)
                .padding()

            if let retryAction = retryAction {
                Button(action: retryAction) {
                    Text(Constants.retryButtonTitle)
                        .frame(height: Constants.buttonHeight)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(Constants.cornerRadius)
                }
            }
        }
        .padding()
    }

    private var errorMessage: String {
        switch error {
        case .noInternet:
            return Constants.noInternet
        case .badRequest:
            return Constants.badRequest
        case .invalidUrl(let urlString):
            return "\(Constants.invalidUrlPrefix)\(urlString)"
        case .unauthorized:
            return Constants.unauthorized
        case .urlSessionFailed(let urlError):
            return "\(Constants.networkErrorPrefix)\(urlError.localizedDescription)"
        case .forbidden:
            return Constants.forbidden
        case .notFound:
            return Constants.notFound
        case .serverError:
            return Constants.serverError
        case .decodableFailure(let decodingError):
            return "\(Constants.decodingFailurePrefix)\(decodingError.localizedDescription)"
        case .error4xx(let code):
            return "\(Constants.clientErrorPrefix)\(code)"
        case .error5xx(let code):
            return "\(Constants.serverErrorPrefix)\(code)"
        case .unknownError:
            return Constants.unknownError
        }
    }

    private enum Constants {
        static let errorIcon = "exclamationmark.triangle"
        static let iconSize: CGFloat = 60
        static let retryButtonTitle = "Retry"
        static let buttonHeight: CGFloat = 44
        static let cornerRadius: CGFloat = 8

        static let noInternet = "No internet connection."
        static let badRequest = "Bad request. Please try again."
        static let invalidUrlPrefix = "Invalid URL: "
        static let unauthorized = "You are not authorized to perform this action."
        static let networkErrorPrefix = "Network error: "
        static let forbidden = "Access forbidden."
        static let notFound = "Requested resource not found."
        static let serverError = "Server encountered an error."
        static let decodingFailurePrefix = "Failed to decode response: "
        static let clientErrorPrefix = "Client error: "
        static let serverErrorPrefix = "Server error: "
        static let unknownError = "An unknown error occurred."
    }
}
