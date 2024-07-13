//
//  MovieDetailView.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/13/24.
//

import SwiftUI
import SwiftData

struct MovieDetailView: View {
    
    @Environment(\.modelContext) var dbContext
    @Environment(MovieDetailModel.self) var movieDetailVM
    @Environment(ReviewViewModel.self) var reviewVM

    @State private var exist = false
    var movie: Movie
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    

    
    var body: some View {
        
        ScrollView {
            
            Image(uiImage: movieDetailVM.movie.posterImage ?? UIImage(named: "noImage")!)
                    .resizable()
                    .scaledToFill()
                    .modifier(StetchyHeaderViewModifier())
            
            VStack {

                HStack {
                    Text(movieDetailVM.movie.title)
                        .bold()
                    
                    Spacer()
                } //VSTACK
                
                HStack {
                    Text(dateformat.string(from: movieDetailVM.movie.releaseDate) + " 개봉")
                    
                    Divider()
                    
                    if let runtime = movieDetailVM.movieDetail?.runtime {
                        Text("\(runtime)분")
                    }
                    Spacer()
                } //HSTACK
                
                HStack {
                    if let genres = movieDetailVM.movieDetail?.genres {
                        ForEach(genres, id: \.id) { genre in
                            Text(genre.name)
                        }
                    }
                    Spacer()
                } //HSTACK
                
                actionButtons

                Divider()
                
                SpacedText("줄거리")
                    .padding(.bottom, 3)
                    .bold()
                
                SpacedText(movieDetailVM.movieDetail?.overview ?? "리뷰가 존재하지 않습니다")
                    .foregroundStyle(.white)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                 
                Divider()
                
                MovieReviewView()
                
            } //VSTACK
            .padding(.top, 40)
                
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movieDetailVM.casts) { data in
                        VStack {
                            Image(uiImage: data.profileImage ?? UIImage(named: "noImage")!)
                                .resizable()
                                .frame(width: 70, height: 100)
                                .clipShape(Circle())
                            Text(data.name)
                                .truncationMode(.tail)
                                .frame(width: 70, height: 50)
                            Spacer()
                        }
                        .padding()

                    }
                } //LAZYHSTACK
            } //SCROLLVIEW
        } //SCROLLVIEW
        .ignoresSafeArea()
        .onAppear {
            movieDetailVM.movie = movie
            reviewVM.movie = movie
            reviewVM.processing = true
            checkMovie()
        }
        .onDisappear {
            movieDetailVM.casts = []
        }
        

    }
    
    

}

extension MovieDetailView {
    var gptSummery: some View {
        VStack {
            SpacedText("GPT 요약")
                .bold()
            
            if !reviewVM.processing && reviewVM.summery.pro.isEmpty && reviewVM.summery.con.isEmpty {
                SpacedText("리뷰가 존재하지 않습니다")
            } else {
                if reviewVM.processing {
                    ProgressView()
                } else {
                    if !reviewVM.summery.pro.isEmpty && !reviewVM.summery.con.isEmpty {
                        SpacedText("긍정적")
                            .bold()
                        SpacedText(reviewVM.summery.pro)
                            .font(.caption2)
                        SpacedText("부정적")
                            .bold()
                        SpacedText(reviewVM.summery.con)
                            .font(.caption2)
                    }
                }
            }
        }

    }
    
}

extension MovieDetailView {
    //MARK: MovieDetailView 버튼들
    var actionButtons: some View {
        HStack {
            Button(action: {
                addMovie(id: movie.id)
            }, label: {
                VStack {
                    Image(systemName: exist ? "checkmark" : "plus")
                    Text("내가 찜한 리스트")
                        .font(.caption2)
                        .padding(.top, 3)
                }.foregroundStyle(Color.white)
            })
            
            Button(action: {
                
            }, label: {
                VStack {
                    Image(systemName: "hand.thumbsup")
                    Text("평가")
                        .font(.caption2)
                        .padding(.top, 3)
                }.foregroundStyle(Color.white)
            }).padding()
            
            Button(action: {
                
            }, label: {
                VStack {
                    Image(systemName: "paperplane")
                    Text("추천")
                        .font(.caption2)
                        .padding(.top, 3)
                }.foregroundStyle(Color.white)
            }).padding()
            
            Spacer()
        }
        .padding(.horizontal)
    }
}

extension MovieDetailView {
    func checkMovie() {
        let id = movieDetailVM.movie.id
        let predicate = #Predicate<FavoriteMovie> { $0.id == id }
        let descriptor = FetchDescriptor<FavoriteMovie>(predicate: predicate)
        guard let count = try? dbContext.fetchCount(descriptor) else { return }
        count > 0 ? (exist = true) : (exist = false)
    }
    
    func addMovie(id: Int) {
        let title = movieDetailVM.movie.title
        let url = movieDetailVM.movie.posterURL
        let date = movieDetailVM.movie.releaseDate
        let predicate = #Predicate<FavoriteMovie> { $0.id == id }
        let descriptor = FetchDescriptor<FavoriteMovie>(predicate: predicate)
        guard let count = try? dbContext.fetchCount(descriptor) else { return }
        do {
            if count > 0 {
                try dbContext.delete(model: FavoriteMovie.self, where: #Predicate { movie in
                    movie.id == id
                })
                exist = false
            } else {
                let favoriteMovie = FavoriteMovie(id: id, posterURL: url, title: title, releaseDate: date)
                dbContext.insert(favoriteMovie)
                exist = true
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    MovieDetailView(movie: Movie.skeletonModels.first!)
        .environment(MoviePopularModel())
        .environment(MovieDetailModel())
        .environment(ReviewViewModel())
        .modelContainer(previewContainer)
}
