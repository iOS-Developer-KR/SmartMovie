//
//  MovieSearchEndPoint.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation


struct MovieSearchEndPoint: APIEndpointable {
    
    let searchQuery: String
    
    init(input: String) {
        self.searchQuery = input
    }
    
    var URLPath: String = "/3/search/movie"
    
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath,
            queryItems: makeQueryItems(),
            headers: makeHeaders()
        )
    }
    
    func makeQueryItems() -> [URLQueryItem]? {
        let languageQueryItem = URLQueryItem(name: "language", value: "ko-KR")
        let adultQueryItem = URLQueryItem(name: "inclue_adult", value: "true")
        let pageNumberQueryItem = URLQueryItem(name: "page", value: "1")
        let searchQueryItem = URLQueryItem(name: "query", value: searchQuery)

        return [languageQueryItem, adultQueryItem, pageNumberQueryItem, searchQueryItem]
    }
    
}
