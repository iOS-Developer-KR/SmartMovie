//
//  MovieReviewView.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 7/13/24.
//

import SwiftUI

struct MovieReviewView: View {
    
    @Environment(ReviewViewModel.self) var reviewVM

    var body: some View {
        VStack {
            DisclosureGroup(
                content: {
                    if !reviewVM.processing && reviewVM.summery.pro.isEmpty && reviewVM.summery.con.isEmpty {
                        SpacedText("리뷰가 존재하지 않습니다")
                            .font(.footnote)
                    } else {
                        if reviewVM.processing {
                            ProgressView()
                        } else {
                            if !reviewVM.summery.pro.isEmpty && !reviewVM.summery.con.isEmpty {
                                SpacedText("긍정적")
                                    .font(.subheadline)
                                    .bold()
                                SpacedText(reviewVM.summery.pro)
                                    .font(.footnote)
                                SpacedText("부정적")
                                    .font(.subheadline)
                                    .bold()
                                SpacedText(reviewVM.summery.con)
                                    .font(.footnote)
                            }
                        }
                    }
                },
                label: { 
                    Text("GPT 리뷰요약")
                        .foregroundStyle(.white)
                }
            )
        }
    }
}

#Preview {
    MovieReviewView()
        .environment(ReviewViewModel())
}
