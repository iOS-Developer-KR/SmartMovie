//
//  ReviewViewModel.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/26/24.
//

import Foundation
import OpenAI


@Observable
class ReviewViewModel {
    let openAI = OpenAI(apiToken: "input_chatgpt_api_key")
    let networkFetcher = NetworkFetcher()
    let networkManager = NetworkManager()
    
    var reviews: [Review] = []
    var summery: Summery = Summery(pro: "", con: "")
    
    var processing = false
    
    var movie: Movie? {
        didSet {
            processing = true
            summery = .init(pro: "", con: "")
            fetchMovieReview()
        }
    }
    
    init(movie: Movie? = nil) {
        self.movie = movie
    }
    
    func fetchMovieReview() {
        guard let movieId = movie?.id else { return }
        let reviewEndPoint = MovieReviewEndPoint(movieId: movieId)
        Task {
            do {
                let decodedData = try await networkManager.fetchData(to: MovieReviewDTO.self, endPoint: reviewEndPoint)
                
                guard let reviews = decodedData as? MovieReviewDTO else { return }

                var tempReview: [Review] = []
                
                for review in reviews.results {
                    tempReview.append(review)
                }
                print("요약하기 전:\(tempReview)")
                // 여기서 gpt한테 분석 요구하기
                self.reviews = tempReview
                await analizeReview(reviews: self.reviews.map({ review in
                    return review.content
                }).joined())
            }
            catch {
                processing = false
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    @MainActor
    func analizeReview(reviews: String) async {
        let functions = [
            ChatQuery.ChatCompletionToolParam(function: .init(
                name: "Analysing-Given-reviews",
                description: "Analyze this reviews of movie",
                parameters:
                        .init(
                            type: .object,
                            properties: [
                                "pro": .init(type: .string, description: "Summarize shortly these reviews that are positive In Korean."),
                                "con": .init(type: .string, description: "Summarize shortly these reviews that are negative In Korean."),
                            ],
                            required: ["pro", "con"]
                        )
                )
             ),
             
        ]
        
        let userParm: ChatQuery.ChatCompletionMessageParam.ChatCompletionUserMessageParam = .init(content: .string(reviews + "\(String(describing: movie?.title)) 영화 리뷰를 요약하는 역할을 할거야."))
        let query = ChatQuery(messages: [.user(userParm)], model: .gpt3_5Turbo, tools: functions)
        
        do {
            let chatsStream = try await openAI.chats(query: query)
            for chat in chatsStream.choices {
                for tool in chat.message.toolCalls! {
                    print(tool.function.arguments.description)
                }
                
                if let toolcalls = chat.message.toolCalls, let arg = toolcalls.first?.function.arguments.data(using: .utf8) {
                    DispatchQueue.main.async {
                        self.summery = try! JSONDecoder().decode(Summery.self, from: arg)
                        print("해독한 json" + self.summery.con + self.summery.pro)
                        self.processing = false
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
