//
//  APIEndPointable.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation

protocol APIEndpointable: URLConstantsHavable {

    var endPoint: EndPoint { get } // url
    var urlRequest: URLRequest? { get }
    func makeQueryItems() -> [URLQueryItem]?
    func makeHeaders() -> [String : String]?

}

//MARK: Extension for urlRequest
extension APIEndpointable {
    
    var urlRequest: URLRequest? {
        var urlComponents = URLComponents(string: endPoint.baseURL)
        
        urlComponents?.path = endPoint.path
        urlComponents?.queryItems = endPoint.queryItems
        
        guard let url = urlComponents?.url else { return nil }
        var urlRequest = URLRequest(url: url)
        endPoint.headers?.forEach({ key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
        return urlRequest
    }
}

//MARK: Extension for base & makeHeaders
extension APIEndpointable {

    // baseURL는 고정
    var baseURL: String {
        get {
            return "https://api.themoviedb.org"
        }
    }

    // Header는 고정
    func makeHeaders() -> [String : String]? {
        let authorizationHeaderKey = "Authorization"
        let authorizationHeaderValue = " Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OThlNDA1NzkzNzU5OWFkY2I1Njc4NTRmODdhNDVmNyIsInN1YiI6IjY2NjdmMmM5NGUzOTM4NDU2YWVhMGZhZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.KUk8jEkDS94uCJst-hEcIIqsUGiLKusbFH8vaPc13OA"

        let acceptionHeaderKey = "accept"
        let acceptionHeaderValue = "application/json"

        return [authorizationHeaderKey: authorizationHeaderValue,
                    acceptionHeaderKey: acceptionHeaderValue]
    }

}
