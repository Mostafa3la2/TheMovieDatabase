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
    func searchMovies(query: String, parameters: [String: String]?) async throws -> MovieListPageDTO {
        var endpoint = Endpoint(path: "/3/search/movie")
        endpoint.queryItems = [URLQueryItem(name: "query", value: query)]
        if parameters != nil {
            endpoint.queryItems?.append(contentsOf: parameters!.map { URLQueryItem(name: $0.key, value: $0.value)})
        }
        let response: MovieListPageDTO = try await NetworkService.shared.request(endpoint: endpoint, responseType: MovieListPageDTO.self)
        return response
    }
    func fetchMovieDetails(movieID: Int) async throws -> MovieDetailsDTO {
        let endpoint = Endpoint(path: "/3/movie/\(movieID)")
        let response: MovieDetailsDTO = try await NetworkService.shared.request(endpoint: endpoint, responseType: MovieDetailsDTO.self)
        return response
    }
    func fetchMovieCast(movieID: Int) async throws -> MovieCastDTO {
        let endpoint = Endpoint(path: "/3/movie/\(movieID)/credits")
        let response: MovieCastDTO = try await NetworkService.shared.request(endpoint: endpoint, responseType: MovieCastDTO.self)
        return response
    }
}
