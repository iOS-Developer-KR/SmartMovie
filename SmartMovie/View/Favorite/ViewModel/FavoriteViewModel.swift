//
//  FavoriteViewModel.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/24/24.
//

import Foundation
import SwiftUI

@Observable
class FavoriteMovieViewModel {
    
    let networkFetcher = NetworkFetcher()
    let networkManager = NetworkManager()
    
    var movies: [Movie] = []
    
    func searchMovies(favoriteMovies: [FavoriteMovie]) {
        Task {
            do {
                DispatchQueue.main.async {
                    self.movies.removeAll()
                }
                for movie in favoriteMovies {
                    let title = movie.title
                    let id = movie.id
                    let posterPath = movie.posterURL
                    let date = movie.releaseDate
                    
                    let imageEndPoint = MovieImageEndPoint(imageURL: posterPath)
                    let imageResult = try await networkFetcher.performRequest(imageEndPoint.urlRequest)
                    
                    await MainActor.run {

                        switch imageResult {
                        case .success(let data):
                            guard let posterImage = UIImage(data: data) else { return }
                            let movie = Movie(id: id, title: title, releaseDate: date, posterImage: posterImage, posterURL: posterPath)
                            self.movies.append(movie)
                            print(movie.title + "이거다 영화는")
                        case .failure(let error):
                            print(error)
                        }
                    }
                } // DISPATCHQUEUE
            } // DO
        }
    }
}
