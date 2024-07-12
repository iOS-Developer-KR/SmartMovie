//
//  MovieFavorite.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/17/24.
//
import Foundation
import SwiftData
import SwiftUI

@Model
class FavoriteMovie: Identifiable {
    var id: Int
    var posterURL: String
    var title: String
    var releaseDate: Date
    
    init(id: Int, posterURL: String, title: String, releaseDate: Date) {
        self.id = id
        self.posterURL = posterURL
        self.title = title
        self.releaseDate = releaseDate
    }
}


