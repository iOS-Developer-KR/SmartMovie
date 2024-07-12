//
//  MovieDetailEndPoint.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/13/24.
//

import Foundation

struct MovieDetailEndPoint: APIEndpointable {
    
    let movieID: String
    let URLPath: String = "/3/movie/"
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath + movieID,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
        )
    }
    
    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")
        return [languageQueryItem]
    }
}
