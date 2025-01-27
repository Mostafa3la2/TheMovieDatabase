//
//  Movie.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

struct MovieListPage {
    let movieList: [Movie]?
    let totalPages, totalResults: Int?
    let page: Int?

}
struct Movie {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
}
struct MovieDetails {
    let id: Int?
    let title: String?
    let posterURL: String?
    let overView: String?
    let rating: Double?
    let genres: [Genre]?
    let releaseDate: String?
    let revenue: Int?
    let runTime: Int?
}
struct MovieCast {
    let id: Int?
    let name: String?
    let character: String?
    let profilePath: String?
}
