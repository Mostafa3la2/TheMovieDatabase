//
//  MoviesRepo.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol MoviesRepo {
    func fetchPopularMovies(parameters: [String: String]) async throws -> MovieListPage
    func searchMovies(query: String, parameters: [String: String]?) async throws -> MovieListPage
    func fetchMovieDetails(movieID: Int) async throws -> MovieDetails
    func fetchMovieCast(movieID: Int) async throws -> [MovieCast]

}
class DefaultMoviesRepo: MoviesRepo {

    private let remoteDataSource: MoviesRemoteDataSource

    init(remoteDataSource: MoviesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    func fetchPopularMovies(parameters: [String: String]) async throws -> MovieListPage {
        return try await remoteDataSource.fetchPopularMovies(parameters: parameters)
    }
    func searchMovies(query: String, parameters: [String: String]?) async throws -> MovieListPage {
        return try await remoteDataSource.searchMovies(query: query, parameters: parameters)
    }
    func fetchMovieDetails(movieID: Int) async throws -> MovieDetails {
        return try await remoteDataSource.fetchMovieDetails(movieID: movieID)
    }
    func fetchMovieCast(movieID: Int) async throws -> [MovieCast] {
        return try await remoteDataSource.fetchMovieCast(movieID: movieID)
    }
}

