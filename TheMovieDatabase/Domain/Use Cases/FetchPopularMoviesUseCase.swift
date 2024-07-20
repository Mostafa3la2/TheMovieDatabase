//
//  FetchPopularMoviesUseCase.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol FetchPopularMoviesUseCase {
    func execute(parameters: [String: String]) async throws -> MovieListPage
}

class DefaultFetchPopularMoviesUseCase: FetchPopularMoviesUseCase {

    private let moviesRepo: MoviesRepo

    init(moviesRepo: MoviesRepo) {
        self.moviesRepo = moviesRepo
    }

    func execute(parameters: [String : String]) async throws -> MovieListPage {
        return try await moviesRepo.fetchPopularMovies()
    }
}
