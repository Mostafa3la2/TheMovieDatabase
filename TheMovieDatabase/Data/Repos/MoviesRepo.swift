//
//  MoviesRepo.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol MoviesRepo {
    func fetchPopularMovies() async throws -> MovieListPage
}
class DefaultMoviesRepo: MoviesRepo {

    private let remoteDataSource: MoviesRemoteDataSource

    init(remoteDataSource: MoviesRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    func fetchPopularMovies() async throws -> MovieListPage {
        return try await remoteDataSource.fetchPopularMovies()
    }
}

