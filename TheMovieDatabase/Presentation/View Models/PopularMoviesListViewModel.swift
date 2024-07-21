//
//  PopularMoviesListViewModel.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

@MainActor
class PopularMoviesListViewModel {

    @Published private(set) var movies: [MoviePresentationModel] = []
    private let fetchMoviesUseCase: FetchPopularMoviesUseCase

    init(fetchMoviesUseCase: FetchPopularMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }

    func fetchPopularMovies() async {
        do {
            let moviesPage = try await fetchMoviesUseCase.execute(parameters: [:])
            self.movies = moviesPage.movieList?.map{MoviePresentationModel(movie: $0)} ?? []
        } catch {
            print("error fetching movies: \(error)")
        }
    }
}
