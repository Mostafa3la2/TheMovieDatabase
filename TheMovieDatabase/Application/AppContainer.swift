//
//  AppContainer.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation
import UIKit

class DIContainer {

    static let shared = DIContainer()

    private init() {}

    func makeAPIClient() -> MoviesAPI {
        return MoviesAPI()
    }

    func makeMovieRemoteDataSource() -> MoviesRemoteDataSource {
        return DefaultRemoteDataSource(moviesAPI: makeAPIClient())
    }

    func makeMoviesRepo() -> MoviesRepo {
        return DefaultMoviesRepo(remoteDataSource: makeMovieRemoteDataSource())
    }

    func makeFetchPopularUseCases() -> FetchPopularMoviesUseCase {
        return DefaultFetchPopularMoviesUseCase(moviesRepo: makeMoviesRepo())
    }
    func makeSearchUseCases() -> SearchMoviesUseCase {
        return DefaultSearchMoviesUseCase(moviesRepo: makeMoviesRepo())
    }
    @MainActor func makePopularMoviesViewModel() -> PopularMoviesListViewModel {
        return PopularMoviesListViewModel(fetchMoviesUseCase: makeFetchPopularUseCases(), searchMoviesUseCase: makeSearchUseCases())
    }

}
