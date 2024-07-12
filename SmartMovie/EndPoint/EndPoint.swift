//
//  EndPoint.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation

struct EndPoint {

    let baseURL: String
    let path: String
    let queryItems: [URLQueryItem]?
    let headers: [String: String]?

    init(
        baseURL: String,
        path: String,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.queryItems = queryItems
        self.headers = headers
    }

}





protocol URLConstantsHavable {

    var baseURL: String { get }
    var URLPath: String { get }

}


