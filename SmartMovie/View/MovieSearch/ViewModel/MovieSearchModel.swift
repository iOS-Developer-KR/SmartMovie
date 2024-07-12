//
//  MovieSearchModel.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import SwiftUI
import Combine

final class MovieSearchModel: ObservableObject {
    
    let networkFetcher = NetworkFetcher()
    let networkManager = NetworkManager()
    
    @Published var textfield: String = ""
    @Published var movies: [Movie] = []
    
    private var cancellable: AnyCancellable?
    
    // 빈 - 이지만 값이 설정되면 검색 시작
    var searchEndPoint = MovieSearchEndPoint(input: "-") {
        didSet {
            searchMovies()
        }
    }
    
    init() {
        cancellable = $textfield
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { searchText in
                print("Searching for: \(searchText)")
                if !searchText.isEmpty {
                    self.searchEndPoint = MovieSearchEndPoint(input: searchText)
                }
            })
    }
    
    private func searchMovies() {
        Task {
            do {
                guard let moviesDTO = try await networkManager.fetchData(to: MovieSearchDTO.self, endPoint: searchEndPoint) as? MovieSearchDTO else { return }
                let movieList = moviesDTO.movies
                
                DispatchQueue.main.async {
                    self.movies.removeAll()
                }
                for movie in movieList {
                    let title = movie.title
                    let id = movie.id
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    guard let date = dateFormatter.date(from: movie.releaseDate) else { return }
                    
                    guard let posterPath = movie.posterPath else { return }
                    
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
