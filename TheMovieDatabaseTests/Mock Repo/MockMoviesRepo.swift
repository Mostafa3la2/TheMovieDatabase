//
//  MockMoviesRepo.swift
//  TheMovieDatabaseTests
//
//  Created by Mostafa Alaa on 22/07/2024.
//

import Foundation
@testable import TheMovieDatabase

class MockMoviesRepo: MoviesRepo {

    var shouldReturnError = false

    func fetchPopularMovies(parameters: [String : String]) async throws -> TheMovieDatabase.MovieListPage {
        if shouldReturnError {
            throw NSError(domain: "Mock Error", code: 0)
        } else {
            return MovieListPage(movieList: [Movie(adult: false,
                                                   backdropPath: "",
                                                   genreIDS: [1],
                                                   id: 1,
                                                   originalLanguage: "EN",
                                                   originalTitle: "Test1",
                                                   overview: "Test1",
                                                   popularity: 90,
                                                   posterPath: "",
                                                   releaseDate: "",
                                                   title: "Test",
                                                   video: false,
                                                   voteAverage: 6.5,
                                                   voteCount: 100),
                                             Movie(adult: false,
                                                   backdropPath: "",
                                                   genreIDS: [3],
                                                   id: 2,
                                                   originalLanguage: "EN",
                                                   originalTitle: "Test2",
                                                   overview: "Test2",
                                                   popularity: 90,
                                                   posterPath: "",
                                                   releaseDate: "",
                                                   title: "Test2",
                                                   video: false,
                                                   voteAverage: 5.5,
                                                   voteCount: 100),
                                             Movie(adult: false,
                                                   backdropPath: "",
                                                   genreIDS: [1], 
                                                   id: 3,
                                                   originalLanguage: "EN",
                                                   originalTitle: "Test3",
                                                   overview: "Test3",
                                                   popularity: 90,
                                                   posterPath: "",
                                                   releaseDate: "",
                                                   title: "Test3",
                                                   video: false,
                                                   voteAverage: 8,
                                                   voteCount: 100)],
                                 totalPages: 3,
                                 totalResults: 6,
                                 page: 1)
        }
    }
    
    func searchMovies(query: String, parameters: [String : String]?) async throws -> TheMovieDatabase.MovieListPage {
        if shouldReturnError {
            throw NSError(domain: "Mock Error", code: 0)
        } else {
            return MovieListPage(movieList: [Movie(adult: false,
                                                   backdropPath: "",
                                                   genreIDS: [1],
                                                   id: 1,
                                                   originalLanguage: "EN",
                                                   originalTitle: "Test1",
                                                   overview: "Test1",
                                                   popularity: 90,
                                                   posterPath: "",
                                                   releaseDate: "",
                                                   title: "Test",
                                                   video: false,
                                                   voteAverage: 6.5,
                                                   voteCount: 100),
                                             Movie(adult: false,
                                                   backdropPath: "",
                                                   genreIDS: [3],
                                                   id: 2,
                                                   originalLanguage: "EN",
                                                   originalTitle: "Test2",
                                                   overview: "Test2",
                                                   popularity: 90,
                                                   posterPath: "",
                                                   releaseDate: "",
                                                   title: "Test2",
                                                   video: false,
                                                   voteAverage: 5.5,
                                                   voteCount: 100),
                                             Movie(adult: false,
                                                   backdropPath: "",
                                                   genreIDS: [1],
                                                   id: 3,
                                                   originalLanguage: "EN",
                                                   originalTitle: "Test3",
                                                   overview: "Test3",
                                                   popularity: 90,
                                                   posterPath: "",
                                                   releaseDate: "",
                                                   title: "Test3",
                                                   video: false,
                                                   voteAverage: 8,
                                                   voteCount: 100)],
                                 totalPages: 3,
                                 totalResults: 6,
                                 page: 1)
        }
    }
    
    func fetchMovieDetails(movieID: Int) async throws -> TheMovieDatabase.MovieDetails {
        return MovieDetails(id: 12, title: "Test", posterURL: "", overView: "", rating: 9, genres: [Genre(id: 2, name: "Horror")], releaseDate: "", revenue: 10000, runTime: 320)
    }
    
    func fetchMovieCast(movieID: Int) async throws -> [TheMovieDatabase.MovieCast] {
        return [MovieCast(id: 1, name: "Leo", character: "Jack", profilePath: "")]
    }
}
