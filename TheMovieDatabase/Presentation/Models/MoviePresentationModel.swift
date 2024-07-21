//
//  MoviePresentationModel.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

struct MoviePresentationModel: Hashable {
    let id: UUID
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    init(movie: Movie) {
        self.adult = movie.adult
        self.backdropPath = movie.backdropPath
        self.genreIDS = movie.genreIDS
        self.originalLanguage = movie.originalLanguage
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.popularity = movie.popularity
        self.posterPath = movie.posterPath
        self.releaseDate = movie.releaseDate
        self.title = movie.title
        self.video = movie.video
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.id = UUID()
    }
}
