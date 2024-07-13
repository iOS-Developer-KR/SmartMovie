//
//  Movie.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation
import SwiftUI

struct Movie: Codable, Identifiable {
    var id: Int
    var title: String
    let releaseDate: Date
    var posterImage: UIImage?
    var posterURL: String

    init(
        id: Int,
        title: String,
        releaseDate: Date,
        posterImage: UIImage? = nil,
        posterURL: String
    ) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.posterImage = posterImage
        self.posterURL = posterURL
    }

    static let skeletonModels: [Movie] = [
        Movie(id: 12312, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 2, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 3, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 4, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 5, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 6, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 7, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
        Movie(id: 8, title: "-", releaseDate: Date(), posterImage: UIImage(named: ""), posterURL: ""),
    ]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate
        case posterImageData
        case url
    }

    // Custom decoding logic
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterURL = try container.decode(String.self, forKey: .url)
        self.releaseDate = try container.decode(Date.self, forKey: .releaseDate)
        
        
        // Decode poster image data and convert to UIImage
        if let posterImageData = try container.decodeIfPresent(Data.self, forKey: .posterImageData) {
            self.posterImage = UIImage(data: posterImageData)
        } else {
            self.posterImage = nil
        }
        
    }

    // Custom encoding logic
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(releaseDate, forKey: .releaseDate)
        
        // Convert UIImage to Data and encode
        if let posterImage = posterImage, let posterImageData = posterImage.pngData() {
            try container.encode(posterImageData, forKey: .posterImageData)
        }
    }
}
