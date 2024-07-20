//
//  FetchPopularMoviesUseCase.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol FetchPopularMoviesUseCase {
    func execute(parameters: [String: String]) async throws -> [MovieListPage]
}
