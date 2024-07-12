//
//  MovieSearchView.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/15/24.
//

import SwiftUI


struct MovieSearchBar: View {
    
    @EnvironmentObject var searchVM: MovieSearchModel

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                TextField("게임, 시리즈, 영화를 검색하세요...", text: $searchVM.textfield)
                    .foregroundColor(.primary)

                if !searchVM.textfield.isEmpty {
                    Button(action: {
                        self.searchVM.textfield = ""
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


struct MovieSearchView: View {
    @EnvironmentObject var searchVM: MovieSearchModel
    
    var body: some View {
        VStack {
            MovieSearchBar()
            
            movieVScrollView(movies: searchVM.movies)
            
            Spacer()
        }
    }
}



#Preview {
    NavigationStack {
        MovieSearchView()
            .environmentObject(MovieSearchModel())
    }
}
