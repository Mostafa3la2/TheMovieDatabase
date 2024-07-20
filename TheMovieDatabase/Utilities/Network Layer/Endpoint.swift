//
//  Endpoint.swift
//  TheMovieDatabase
//
//  Created by Mostafa Alaa on 21/07/2024.
//

import Foundation

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]?
    let method: HTTPMethod

    init(path: String, queryItems: [URLQueryItem]? = nil, method: HTTPMethod = .GET) {
        self.path = path
        self.queryItems = queryItems
        self.method = method
    }

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = path
        components.queryItems = queryItems
        return components.url
    }
}
