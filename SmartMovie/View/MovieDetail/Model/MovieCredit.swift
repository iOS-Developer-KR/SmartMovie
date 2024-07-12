//
//  MovieCredit.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation
import SwiftUI

struct MovieCredit: Identifiable {
    let id: Int
    let name: String
    let characterName: String?
    let profileImage: UIImage?

    init(id: Int, name: String, characterName: String?, profileImage: UIImage?) {
        self.id = id
        self.name = name
        self.characterName = characterName
        self.profileImage = profileImage
    }

    static var fakeModels = [MovieCredit](
        repeating: MovieCredit(id: 1, name: "-", characterName: "-", profileImage: UIImage(named: "noImage")),
        count: 16
    )

}
