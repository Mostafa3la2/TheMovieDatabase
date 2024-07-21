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
    private var moviesPage: MovieListPage?
    private let fetchMoviesUseCase: FetchPopularMoviesUseCase
    private var currentPage = 1
    @Published private(set) var isFetching: Bool = false
    private var canLoadMorePages = true

    init(fetchMoviesUseCase: FetchPopularMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }

    func fetchPopularMovies(resetPage: Bool = false) async {
        if resetPage {
            currentPage = 1
            canLoadMorePages = true
            moviesPage = nil
            movies = []
        }
        guard !isFetching else { return }
        isFetching = true
        var parameters = ["page": "\(currentPage)"]
        do {
            let moviesPage = try await fetchMoviesUseCase.execute(parameters: parameters)
            let newMovies = moviesPage.movieList?.map{MoviePresentationModel(movie: $0)} ?? []
            self.movies.append(contentsOf: newMovies)
            currentPage += 1
            self.canLoadMorePages = moviesPage.totalPages != currentPage || currentPage > moviesPage.totalPages ?? Int.max // just in case for some reasons current page exceeded total pages
            isFetching = false
        } catch {
            print("error fetching movies: \(error)")
            isFetching = false
        }
    }
    func fetchNextPage() async{
        await fetchPopularMovies()
    }
}
