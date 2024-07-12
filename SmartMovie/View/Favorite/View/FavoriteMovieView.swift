//
//  FavoriteMovieView.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/22/24.
//

import SwiftUI
import SwiftData

struct FavoriteSearchBar: View {
    
    @Binding var textfield: String

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("게임, 시리즈, 영화를 검색하세요...", text: $textfield)
                    .foregroundColor(.primary)

                if !textfield.isEmpty {
                    Button(action: {
                        self.textfield = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(5.0)
        }
        .padding(.horizontal)
    }
}


struct FavoriteMovieView: View {
    
    @Query var favoriteMovies: [FavoriteMovie]
    @Environment(FavoriteMovieViewModel.self) var favoriteVM
    @State private var textfield: String = ""
    var body: some View {
        VStack {
            FavoriteSearchBar(textfield: $textfield)
            
            if textfield.isEmpty {
                movieVScrollView(movies: favoriteVM.movies)
            } else {
                movieVScrollView(movies: favoriteVM.movies.filter({ movie in
                    movie.title.localizedCaseInsensitiveContains(textfield)
                }))
            }
                
        }
        .onAppear {
            favoriteVM.searchMovies(favoriteMovies: favoriteMovies)
        }
    }
}

#Preview {
    FavoriteMovieView()
        .environment(FavoriteMovieViewModel())
        .environment(MoviePopularModel())
        .environment(MovieDetailModel())
        .environmentObject(MovieSearchModel())
}
