//
//  FetchMovieCastUseCase.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation

protocol FetchMovieCastUseCase {
    func execute(movieID: Int) async throws -> [MovieCast]
}
class DefaultFetchMovieCastUseCase: FetchMovieCastUseCase {

    private let movieRepo: MoviesRepo

    init(movieRepo: MoviesRepo) {
        self.movieRepo = movieRepo
    }

    func execute(movieID: Int) async throws -> [MovieCast] {
        return try await movieRepo.fetchMovieCast(movieID: movieID)
    }
}
