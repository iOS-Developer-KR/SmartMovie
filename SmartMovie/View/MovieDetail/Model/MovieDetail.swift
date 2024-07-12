//
//  MovieDetail.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/13/24.
//

import Foundation
import SwiftUI

struct MovieDetail {

    let posterImage: UIImage
    let koreanTitle: String
    let originalTitle: String
    let releaseDate: String
    let countries: [ProductionCountry]
    let genres: [Genre]
    let runtime: Int
    let tagLine: String
    let overview: String

}
