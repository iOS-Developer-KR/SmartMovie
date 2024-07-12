//
//  MovieReviewDTO.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/13/24.
//

import Foundation


// MARK: - Review
struct MovieReviewDTO: Codable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages, totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


