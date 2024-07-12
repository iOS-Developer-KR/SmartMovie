//
//  MovieDetailModel.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation
import SwiftUI
import OpenAI

@Observable
final class MovieDetailModel {
    let openAI = OpenAI(apiToken: "insert_your_api_key")
    let networkFetcher = NetworkFetcher()
    let networkManager = NetworkManager()
    var movieDetail: MovieDetail?
    var casts: [MovieCredit] = []


    var movie: Movie {
        didSet {
            fetchCredits()
            fetchMovieDetail()
        }
    }
    
    init(movie: Movie = Movie.skeletonModels.first!) {
        self.movie = movie
    }

    
    func fetchCredits() {
        let movieId = movie.id
        let creditEndPoint = MovieCreditsEndPoint(movieId: movieId)
        Task {
            let decodedData = try await networkManager.fetchData(to: MovieCreditsDTO.self, endPoint: creditEndPoint)
            
            guard let credits = decodedData as? MovieCreditsDTO else { return }
            
            let creditList = credits.cast + credits.crew
            var tempCredits: [MovieCredit] = []
            
            for credit in creditList {
                let name = credit.name
                let characterName = credit.characterName
                let id = credit.id
                
                guard let profilePath = credit.profilePath else { return }
                let imageEndPoint = MovieImageEndPoint(imageURL: profilePath)
                let imageResult = try await networkFetcher.performRequest(imageEndPoint.urlRequest)
                
                switch imageResult {
                case .success(let data):
                    guard let profileImage = UIImage(data: data) else { return }
                    let newCredit = MovieCredit(id: id,name: name, characterName: characterName, profileImage: profileImage)
                    tempCredits.append(newCredit)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                casts = tempCredits
            }
        }
    }
    
    func fetchMovieDetail() {
        let movieId = self.movie.id
        let detailEndPoint = MovieDetailEndPoint(movieID: String(movieId))
        Task {
            let decodedData = try await networkManager.fetchData(to: MovieDetailDTO.self, endPoint: detailEndPoint)
            
            guard let detailDTO = decodedData as? MovieDetailDTO else { return }
            let imageEndPoint = MovieImageEndPoint(imageURL: detailDTO.posterPath)
            let imageResult = try await networkFetcher.performRequest(imageEndPoint.urlRequest)
            
            switch imageResult {
            case .success(let data):
                guard let posterImage = UIImage(data: data) else { return }
                movieDetail = generateMovieDetail(with: detailDTO, posterImage)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    func generateMovieDetail(
        with movieDetailsDTO: MovieDetailDTO,
        _ posterImage: UIImage
    ) -> MovieDetail {
        return MovieDetail(
            posterImage: posterImage,
            koreanTitle: movieDetailsDTO.title,
            originalTitle: movieDetailsDTO.originalTitle,
            releaseDate: movieDetailsDTO.releaseDate,
            countries: movieDetailsDTO.productionCountries,
            genres: movieDetailsDTO.genres,
            runtime: movieDetailsDTO.runtime,
            tagLine: movieDetailsDTO.tagline,
            overview: movieDetailsDTO.overview
        )
    }
    
    
}

//import Foundation
//import OpenAI
//import SwiftData
//
//@Model
//class Message {
//    @Attribute(.unique) var id: String
//    var role: ChatQuery.ChatCompletionMessageParam.Role
//    var content: Data
//    var createdAt: Date
//    
//    init(id: String, role: ChatQuery.ChatCompletionMessageParam.Role, content: Data, createdAt: Date) {
//        self.id = id
//        self.role = role
//        self.content = content
//        self.createdAt = createdAt
//    }
//    
//}
//
//extension Message: Identifiable {}
