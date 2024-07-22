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
    @Published var error: Error?
    private var moviesPage: MovieListPage?
    private let fetchMoviesUseCase: FetchPopularMoviesUseCase
    private let searchMoviesUseCase: SearchMoviesUseCase
    private var currentPage = 1
    @Published private(set) var isFetching: Bool = false
    private var canLoadMorePages = true
    var pageState: PageState = .normal
    private var searchQuery: String?
    enum PageState {
        case search
        case normal
    }
    init(fetchMoviesUseCase: FetchPopularMoviesUseCase, searchMoviesUseCase: SearchMoviesUseCase) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.searchMoviesUseCase = searchMoviesUseCase
    }

    func fetchPopularMovies(resetPage: Bool = false, filter: [String: String] = [:]) async {
        if resetPage {
            currentPage = 1
            canLoadMorePages = true
            moviesPage = nil
            movies = []
            searchQuery = nil
        }
        pageState = .normal
        guard !isFetching else { return }
        isFetching = true
        let parameters = ["page": "\(currentPage)"]
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
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }

    func searchMovies(firstSearch: Bool = false, with query: String, pagination: Bool = false) async {
        if firstSearch {
            moviesPage = nil
            movies = []
            currentPage = 1
            canLoadMorePages = true
        }
        guard !isFetching else { return }
        isFetching = true
        searchQuery = query
        self.pageState = .search
        let parameters = ["page": "\(currentPage)"]
        do {
            let moviesPage = try await searchMoviesUseCase.execute(query: searchQuery ?? "", parameters: parameters)
            let newMovies = moviesPage.movieList?.map{MoviePresentationModel(movie: $0)} ?? []
            if pagination {
                self.movies.append(contentsOf: newMovies)
            } else{
                self.movies = newMovies
            }
            currentPage += 1
            self.canLoadMorePages = moviesPage.totalPages != currentPage || currentPage > moviesPage.totalPages ?? Int.max // just in case for some reasons current page exceeded total pages
            isFetching = false
        } catch {
            print("error fetching movies: \(error)")
            isFetching = false
            DispatchQueue.main.async {
                self.error = error
            }
        }
    }
    func fetchNextPage() async{
        switch pageState {
        case .normal:
            await fetchPopularMovies()
        case .search:
            await searchMovies(with: searchQuery ?? "", pagination: true)
        }
    }
}
