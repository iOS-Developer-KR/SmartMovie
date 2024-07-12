//
//  SmartMovieApp.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import SwiftUI

@main
struct SmartMovieApp: App {
    
    @State private var popularmovie = MoviePopularModel()
    @State private var detailemovie = MovieDetailModel()
    @State private var searchmovie = MovieSearchModel()
    @State private var favoritemovie = FavoriteMovieViewModel()
    @State private var reviewmovie = ReviewViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(popularmovie)
                .environment(detailemovie)
                .environment(favoritemovie)
                .environment(reviewmovie)
                .environmentObject(searchmovie)
                .modelContainer(for: [FavoriteMovie.self])
        }
    }
}
