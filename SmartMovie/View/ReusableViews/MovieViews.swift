//
//  MovieViews.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/24/24.
//

import Foundation
import SwiftUI

//MARK: 가로 스크롤뷰
func movieHScrollView(movies: [Movie]) -> some View {
    VStack {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(movies, id: \.id) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        MovieHThumbnailView(movie: movie)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

//MARK: 영화 썸네일 + 제목
func MovieHThumbnailView(movie: Movie) -> some View {
    VStack {
        if let image = movie.posterImage {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
            
            Text(movie.title)
                .foregroundStyle(Color.gray)
                .lineLimit(1)
                .truncationMode(.tail)
        } else {
            ProgressView()
                .progressViewStyle(.circular)
        }
        
    }
    .frame(width: 100, height: 200)
}

//MARK: 3xn 영화 리스트
func movieVScrollView(
    columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3),
    movies: [Movie]
) -> some View {
    ScrollView(.vertical) {
        LazyVGrid(columns: columns) {
            ForEach(movies, id: \.id) { movie in
                NavigationLink {
                    MovieDetailView(movie: movie)
                } label: {
                    MovieHThumbnailView(movie: movie)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
