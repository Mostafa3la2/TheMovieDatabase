//
//  NetworkService.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func request<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {
        guard let url = endpoint.url else {
            throw NetworkError.badURL
        }

        var request = URLRequest(url: url)
        print("request is \(request.url)")
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(APIConstants.accessToken)"
        ]
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }

            switch httpResponse.statusCode {
            case 200...299:
                break
            case 400...499:
                throw NetworkError.requestFailed
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw NetworkError.unknown
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingFailed
            }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            } else {
                throw NetworkError.unknown
            }
        }
    }
}
