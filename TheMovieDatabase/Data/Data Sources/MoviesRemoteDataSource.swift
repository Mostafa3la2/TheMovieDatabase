//
//  MoviesRemoteDataSource.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol MoviesRemoteDataSource {
    func fetchPopularMovies(parameters: [String: String]) async throws -> MovieListPage
    func searchMovies(query: String, parameters: [String: String]?) async throws -> MovieListPage
    func fetchMovieDetails(movieID: Int) async throws -> MovieDetails
    func fetchMovieCast(movieID: Int) async throws -> [MovieCast]

}

class DefaultRemoteDataSource: MoviesRemoteDataSource {

    private let moviesAPI: MoviesAPI

    init(moviesAPI: MoviesAPI) {
        self.moviesAPI = moviesAPI
    }
    func fetchPopularMovies(parameters: [String: String]) async throws -> MovieListPage {
        return try await moviesAPI.fetchPopularMovies(parameters: parameters).toDomain()
    }
    func searchMovies(query: String, parameters: [String: String]?) async throws -> MovieListPage {
        return try await moviesAPI.searchMovies(query: query, parameters: parameters).toDomain()
    }
    func fetchMovieDetails(movieID: Int) async throws -> MovieDetails {
        return try await moviesAPI.fetchMovieDetails(movieID: movieID).toDomain()
    }
    func fetchMovieCast(movieID: Int) async throws -> [MovieCast] {
        return try await moviesAPI.fetchMovieCast(movieID: movieID).cast!.map{$0.toDomain()}
    }
}
