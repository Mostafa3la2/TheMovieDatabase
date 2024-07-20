//
//  NetworkError.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case badURL
    case requestFailed
    case unknown
    case noData
    case decodingFailed
    case invalidResponse
    case serverError(statusCode: Int)
    case encodingFailed

    var errorDescription: String? {
        switch self {
        case .badURL:
            return "The URL is invalid."
        case .requestFailed:
            return "The request failed."
        case .unknown:
            return "An unknown error occurred."
        case .noData:
            return "No data was received."
        case .decodingFailed:
            return "Failed to decode the response."
        case .invalidResponse:
            return "The response was invalid."
        case .serverError(let statusCode):
            return "Server error with status code: \(statusCode)."
        case .encodingFailed:
            return "Failed to encode the request body."
        }
    }
}
