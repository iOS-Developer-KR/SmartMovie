//
//  MoviePopularModel.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation
import SwiftUI

@Observable
final class MoviePopularModel {
    
    let networkFetcher = NetworkFetcher()
    let networkManager = NetworkManager()
        
    var movies: [Movie] = Movie.skeletonModels
    
    
    // 빈 - 이지만 값이 설정되면 검색 시작
    var popularEndPoint = MoviePopularEndPoint(input: "-") {
        didSet {
            fetchMovies()
        }
    }
    
    func fetchMovies() {
        Task {
            do {
                guard let moviesDTO = try await networkManager.fetchData(to: MoviesDTO.self, endPoint: popularEndPoint) as? MoviesDTO else { return }

                let movieList = moviesDTO.movies
                var movies: [Movie] = []
                for movie in movieList {
                    let title = movie.title
                    let id = movie.id
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    guard let date = dateFormatter.date(from: movie.releaseDate) else { return }
                    guard let posterPath = movie.posterPath else { return }

                    let imageEndPoint = MovieImageEndPoint(imageURL: posterPath)
                    let imageResult = try await networkFetcher.performRequest(imageEndPoint.urlRequest)

                    switch imageResult {
                    case .success(let data):
                        guard let posterImage = UIImage(data: data) else { return }
                        let movie = Movie(id: id, title: title, releaseDate: date, posterImage: posterImage, posterURL: posterPath)
                        movies.append(movie)
                    case .failure(let error):
                        print(error)
                    }
                }
                self.movies = movies
            }
        }
    }
}
