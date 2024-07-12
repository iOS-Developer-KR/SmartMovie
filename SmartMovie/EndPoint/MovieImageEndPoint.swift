//
//  MovieImageAPIEndPoint.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation


struct MovieImageEndPoint: APIEndpointable {

    let imageURL: String
    var URLPath: String = "/t/p/original"
    var baseURL: String = "https://image.tmdb.org"
    var endPoint: EndPoint {
        return EndPoint(
            baseURL: baseURL,
            path: URLPath + imageURL
            )
    }

    init(imageURL: String) {
        self.imageURL = imageURL
    }

    // No Query Required for Get Image Request
    func makeQueryItems() -> [URLQueryItem]? {
        return nil
    }

}
