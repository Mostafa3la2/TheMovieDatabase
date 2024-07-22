//
//  FetchMovieDetailsUseCase.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation

protocol FetchMovieDetailsUseCase {
    func execute(movieID: Int) async throws -> MovieDetails
}

class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {

    private let movieRepo: MoviesRepo

    init(movieRepo: MoviesRepo) {
        self.movieRepo = movieRepo
    }

    func execute(movieID: Int) async throws -> MovieDetails {
        return try await movieRepo.fetchMovieDetails(movieID: movieID)
    }
}
