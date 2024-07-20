//
//  MoviesRepo.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

protocol MoviesRepo {
    func fetchMovies() async throws -> [MovieListPage]
}

