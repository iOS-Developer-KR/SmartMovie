//
//  MovieSearchDTO.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/15/24.
//

import Foundation

struct MovieSearchDTO: Codable {
    let page: Int
    let movies: [MovieSearchModelsResult]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"  // 여기를 "results"로 수정
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


// MARK: - Movie Model
struct MovieSearchModelsResult: Identifiable, Codable {
    let id: Int
    let title: String
    let originalTitle: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let genreIds: [Int]
    let adult: Bool
    let originalLanguage: String
    let video: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case genreIds = "genre_ids"
        case adult
        case originalLanguage = "original_language"
        case video
    }


}


