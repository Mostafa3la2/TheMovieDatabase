//
//  MovieDetailsViewModel.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation
import Combine

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    @Published private(set) var movieDetails: MovieDetails?
    @Published private(set) var movieCast: [MovieCast]?

    private let fetchMovieDetailsUseCase: FetchMovieDetailsUseCase
    private let fetchMovieCastUseCase: FetchMovieCastUseCase

    private var cancellables = Set<AnyCancellable>()

    init(fetchMovieDetailsUseCase: FetchMovieDetailsUseCase, fetchMovieCastUseCase: FetchMovieCastUseCase) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
        self.fetchMovieCastUseCase = fetchMovieCastUseCase
    }

    func fetchMovieDetails(movieID: Int) async {
        do {
            let details = try await fetchMovieDetailsUseCase.execute(movieID: movieID)
            self.movieDetails = details
        } catch {
            print("Error fetching movie details: \(error)")
        }
    }
    func fetchMovieCast(movieID: Int) async {
        do {
            let cast = try await fetchMovieCastUseCase.execute(movieID: movieID)
            self.movieCast = cast
        } catch {
            print("Error fetching movie details: \(error)")
        }
    }
}
