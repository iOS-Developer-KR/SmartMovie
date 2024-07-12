//
//  ReviewModel.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/29/24.
//

import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let author: String
    let author_details: AuthorDetails
    let content: String
    let created_at: String
    let updated_at: String
    let url: String
    
}

struct AuthorDetails: Codable {
    let name: String
    let username: String
    let avatar_path: String?
    let rating: Int
    
}
