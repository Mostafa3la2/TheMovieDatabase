//
//  MoviesAPI.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

class MoviesAPI {

    func fetchPopularMovies(parameters: [String: String]) async throws -> MovieListPageDTO {
        var endpoint = Endpoint(path: "/3/movie/popular")
        endpoint.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value)}
        let response: MovieListPageDTO = try await NetworkService.shared.request(endpoint: endpoint, responseType: MovieListPageDTO.self)
        return response
    }
}
