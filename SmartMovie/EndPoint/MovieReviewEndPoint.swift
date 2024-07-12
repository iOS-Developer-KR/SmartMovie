//
//  MovieReviewEndPoint.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/13/24.
//

import Foundation

struct MovieReviewEndPoint: APIEndpointable {
    
    private enum URLConstants {
        static let URLPathPrefix = "/3/movie/"
        static let URLPathSuffix = "/reviews"
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
        let pageQueryItem = URLQueryItem(name: "page", value: "1")
        return [pageQueryItem]
    }
}
