//
//  TestDIContainer.swift
//  TheMovieDatabaseTests
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation
@testable import TheMovieDatabase
class TestDIContainer {
    static let shared = TestDIContainer()

    private init() {}

    func makeAPIClient() -> MoviesAPI {
        return MoviesAPI()
    }
    func makeMockRepo() -> MockMoviesRepo {
        return MockMoviesRepo()
    }
    func makeDataSource(api: MoviesAPI) -> DefaultRemoteDataSource {
        return DefaultRemoteDataSource(moviesAPI: api)
    }
    func makeFetchPopularUseCase(repo: MoviesRepo) -> FetchPopularMoviesUseCase {
        return DefaultFetchPopularMoviesUseCase(moviesRepo: makeMockRepo())
    }
    func makeSearchUseCase(repo: MoviesRepo) -> SearchMoviesUseCase {
        return DefaultSearchMoviesUseCase(moviesRepo: makeMockRepo())
    }
    func makeGetDetails(repo: MoviesRepo) -> DefaultFetchMovieDetailsUseCase {
        return DefaultFetchMovieDetailsUseCase(movieRepo: makeMockRepo())
    }
    func makeGetCast(repo: MoviesRepo) -> DefaultFetchMovieCastUseCase {
        return DefaultFetchMovieCastUseCase(movieRepo: makeMockRepo())
    }
    @MainActor func makeListVM(getPopularUseCase: FetchPopularMoviesUseCase, searchUseCase: SearchMoviesUseCase) -> PopularMoviesListViewModel {
        return PopularMoviesListViewModel(fetchMoviesUseCase: getPopularUseCase, searchMoviesUseCase: searchUseCase)
    }
}
