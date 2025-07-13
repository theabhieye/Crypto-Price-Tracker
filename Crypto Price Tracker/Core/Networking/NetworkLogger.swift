//
//  NetworkLogger.swift
//  Crypto Price Tracker
//
//  Created by Abhishek kapoor on 13/07/25.
//

import Foundation

final class NetworkLogger {
    private static let isLoggingEnabled = false
    
    static func logRequest<T: Decodable>(
        _ request: NetworkingRequestType,
        response: URLResponse?,
        responseType: T.Type,
        data: Data?,
        error: Error?,
        duration: TimeInterval
    ) {
        guard isLoggingEnabled else { return }

        var logString = ""
        
        logString += "\n---- 📡 Network Request Start ----\n"
        logString += "🔗 URL: \(request.fullPath)\n"
        logString += "📬 Method: \(request.method.rawValue)\n"
        logString += "📦 Headers: \(request.headers)\n"
        logString += "Params: \((request.parameters ?? [:]).debugDescription)\n"
        logString += "Query Params: \(request.queryParam.debugDescription)\n"

        if let httpResponse = response as? HTTPURLResponse {
            logString += "✅ Status Code: \(httpResponse.statusCode)\n"
            logString += "📥 Response Headers: \(httpResponse.allHeaderFields)\n"
        } else if let response = response {
            logString += "ℹ️ Response: \(response)\n"
        } else {
            logString += "⚠️ No response received.\n"
        }

        logString += "⏱ Duration: \(String(format: "%.3f", duration)) seconds\n"

        if let data = data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    logString += "📨 Response Data:\n\(prettyString)\n"
                } else {
                    logString += "📨 Response Data (raw): \(data)\n"
                }
            } catch {
                if let stringData = String(data: data, encoding: .utf8) {
                    logString += "📨 Response Data (non-JSON): \(stringData)\n"
                } else {
                    logString += "📨 Response Data: \(data)\n"
                }
            }
        } else {
            logString += "📭 No response data.\n"
        }

        if let error = error {
            logString += "❌ Error: \(error.localizedDescription)\n"
        }

        logString += "---- 📡 Network Request End ----\n"

        print(logString)
    }
}

