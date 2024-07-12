//
//  NetworkFetcher.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation


struct NetworkFetcher {
    
    typealias NetworkResult = Result<Data, NetworkError>
    
    func performRequest(_ urlRequest: URLRequest?) async throws -> NetworkResult {
        let session = URLSession.shared
        
        guard let urlRequest else { return .failure(.invalidURL) }
        let (data, response) = try await session.data(for: urlRequest)
        guard response.isValidResponse else {
            return .failure(.outOfResponseCode)
        }
        
        return .success(data)
    }
    
}


struct NetworkManager {
    
    private let decoder = JSONDecoder()
    let networkDispatcher = NetworkFetcher()

    func fetchData(
        to type: Decodable.Type,
        endPoint: APIEndpointable
    ) async throws -> Decodable? {
        let urlRequest = endPoint.urlRequest
        let result = try await networkDispatcher.performRequest(urlRequest)

        switch result {
        case .success(let data):
            let decodedData = try decoder.decode(type, from: data)
            return decodedData
        case .failure(let error):
            print(error.errorDescription)
            return nil
        }
    }

}
