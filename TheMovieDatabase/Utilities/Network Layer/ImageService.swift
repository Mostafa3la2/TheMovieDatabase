//
//  ImageService.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

enum ImageQuality {
    case medium
    case high
    case original
}

func constructImageURL(path: String, withQuality: ImageQuality) -> URL? {
    var quality = ""
    switch withQuality {
    case .medium:
        quality = "w300"
    case .high:
        quality = "w500"
    case .original:
        quality = "original"
    }
    let url = "https://image.tmdb.org/t/p/\(quality)/\(path)"
    return URL(string: url)

}
