//
//  MovieCreditsDTO.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation

struct MovieCreditsDTO: Codable {

    let cast: [Cast]
    let crew: [Cast]

}

struct Cast: Codable, Equatable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    let characterName: String?
    let department: String
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
        case characterName = "character"
        case department = "known_for_department"
        case popularity
    }
}
