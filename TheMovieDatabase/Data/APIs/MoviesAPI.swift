//
//  MoviesAPI.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

class MoviesAPI {

    func fetchPopularMovies() async throws -> MovieListPageDTO {
        let endpoint = Endpoint(path: "/3/movie/popular")
        let response: MovieListPageDTO = try await NetworkService.shared.request(endpoint: endpoint, responseType: MovieListPageDTO.self)
        return response
    }
}
