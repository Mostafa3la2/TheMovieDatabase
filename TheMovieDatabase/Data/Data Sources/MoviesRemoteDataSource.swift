//
//  MoviesRemoteDataSource.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol MoviesRemoteDataSource {
    func fetchPopularMovies() async throws -> MovieListPage
}

class DefaultRemoteDataSource: MoviesRemoteDataSource {

    private let moviesAPI: MoviesAPI

    init(moviesAPI: MoviesAPI) {
        self.moviesAPI = moviesAPI
    }
    func fetchPopularMovies() async throws -> MovieListPage {
        return try await moviesAPI.fetchPopularMovies().toDomain()
    }
}
