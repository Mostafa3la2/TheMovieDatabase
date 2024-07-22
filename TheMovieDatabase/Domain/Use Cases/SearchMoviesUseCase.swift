//
//  SearchMoviesUseCase.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(query: String, parameters: [String: String]?) async throws -> MovieListPage
}

class DefaultSearchMoviesUseCase: SearchMoviesUseCase {

    private let moviesRepo: MoviesRepo

    init(moviesRepo: MoviesRepo) {
        self.moviesRepo = moviesRepo
    }

    func execute(query: String, parameters: [String: String]?) async throws -> MovieListPage {
        return try await moviesRepo.searchMovies(query: query, parameters: parameters)
    }
}
