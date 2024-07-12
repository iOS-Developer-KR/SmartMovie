//
//  ContentView.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import SwiftUI

import SwiftUI

struct MainView: View {
    
    @Environment(MoviePopularModel.self) var movie
    @Namespace private var namespace
    @State private var selected: String = "인기순"
    var categories: [String] = ["인기순", "개봉일"]
    var movies: [Movie] {
        get {
            switch selected {
            case categories[0]:
                return movie.movies
            case categories[1]:
                return movie.movies.sorted(by: { m1, m2 in
                    m1.releaseDate > m2.releaseDate
                })
            default:
                return []
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                SpacedText("무비차트")
                    .font(.title)
                
                SelectionView
                
                movieHScrollView(movies: movies)
                Spacer()
            }
            .scrollIndicators(.hidden)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        FavoriteMovieView()
                    } label: {
                        Image(systemName: "star")
                            .foregroundStyle(Color.yellow)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        MovieSearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
        .task {
            movie.fetchMovies()
        }
    }
}

extension MainView {
    var SelectionView: some View {
        HStack {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    if selected == category {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.5))
                            .matchedGeometryEffect(id: "category_background", in: namespace)
                            .frame(width: 35, height: 2)
                            .offset(y: 10)
                    }
                    
                    Text(category)
                        .foregroundStyle(selected == category ? .red : .white)
                }
                .onTapGesture {
                    withAnimation {
                        selected = category
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
    }
}



#Preview {
    MainView()
        .environment(MoviePopularModel())
        .environment(MovieDetailModel())
        .environment(ReviewViewModel())
        .modelContainer(previewContainer)
}
