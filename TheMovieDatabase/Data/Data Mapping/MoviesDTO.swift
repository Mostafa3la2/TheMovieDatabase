//
//  MoviesDTO.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

// MARK: - MovieListPage
struct MovieListPageDTO: Codable {
    let page: Int?
    let movieList: [MovieDTO]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page
        case movieList = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieDTO: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum OriginalLanguage: String, Codable {
    case en = "en"
    case es = "es"
    case fr = "fr"
    case zh = "zh"
}

extension MovieDTO {
    func toDomain() -> Movie {
        return .init(adult: self.adult, backdropPath: self.backdropPath, genreIDS: self.genreIDS, id: self.id, originalLanguage: self.originalLanguage, originalTitle: self.originalTitle, overview: self.overview, popularity: self.popularity, posterPath: self.posterPath, releaseDate: self.releaseDate, title: self.title, video: self.video, voteAverage: self.voteAverage, voteCount: self.voteCount)
    }
}
extension MovieListPageDTO {
    func toDomain() -> MovieListPage {
        return .init(movieList: self.movieList?.map{$0.toDomain()},
                     totalPages: self.totalPages,
                     totalResults: self.totalResults,
                     page: self.page)
    }
}
