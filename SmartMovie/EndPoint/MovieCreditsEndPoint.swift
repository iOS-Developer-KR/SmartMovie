//
//  MovieCreditsEndPoint.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation

struct MovieCreditsEndPoint: APIEndpointable {
    //https://api.themoviedb.org/3/movie/{movie_id}/credits
    private enum URLConstants {
        static let URLPathPrefix = "/3/movie/"
        static let URLPathSuffix = "/credits"
    }
    
    let movieId: String
    var URLPath: String
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
            )
    }

    init(movieId: Int) {
        self.movieId = String(movieId)
        self.URLPath = URLConstants.URLPathPrefix + self.movieId + URLConstants.URLPathSuffix
    }

    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")
        return [languageQueryItem]
    }

}
