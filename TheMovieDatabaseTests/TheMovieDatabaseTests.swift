//
//  TheMovieDatabaseTests.swift
//  TheMovieDatabaseTests
//
//  Created by Mostafa Alaa on 20/07/2024.
//

import XCTest
@testable import TheMovieDatabase

@MainActor
final class TheMovieDatabaseTests: XCTestCase {

    private var viewModel: PopularMoviesListViewModel!
    private var moviesAPI: MoviesAPI!
    private var dataSource: MoviesRemoteDataSource!
    private var repository: MockMoviesRepo!
    private var popluarUseCase: FetchPopularMoviesUseCase!
    private var searchUseCase: SearchMoviesUseCase!

    @MainActor override func setUp()  {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // this is just an example, we can create different classes and mocks and pass them to test the layer next
        moviesAPI = TestDIContainer.shared.makeAPIClient()
        dataSource = TestDIContainer.shared.makeDataSource(api: moviesAPI)

        // here we mock the repo layer
        repository = TestDIContainer.shared.makeMockRepo()
        popluarUseCase = TestDIContainer.shared.makeFetchPopularUseCase(repo: repository)
        searchUseCase = TestDIContainer.shared.makeSearchUseCase(repo: repository)
        viewModel = TestDIContainer.shared.makeListVM(getPopularUseCase: popluarUseCase, searchUseCase: searchUseCase)

    }

    override func tearDown()  {
        viewModel = nil
        moviesAPI = nil
        dataSource = nil
        repository = nil
        popluarUseCase = nil
        searchUseCase = nil
        super.tearDown()
    }

    func testPageState() async {
        await viewModel.searchMovies(with: "")
        assert(viewModel.pageState == .search)
    }

}
