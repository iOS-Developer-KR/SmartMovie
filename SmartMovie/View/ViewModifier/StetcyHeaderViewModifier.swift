//
//  StetcyHeaderViewModifier.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/15/24.
//

import Foundation
import SwiftUI


struct StetchyHeaderViewModifier: ViewModifier {
    
    var startingHeight: CGFloat = 300
    var coordinateSpace: CoordinateSpace = .global
    
    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            content
                .frame(width: geometry.size.width, height: stretchedHeight(geometry))
                .clipped()
                .offset(y: strechedOffset(geometry))
        })
        .frame(height: startingHeight)
    }
    
    private func yOffset(_ geo: GeometryProxy) -> CGFloat {
        geo.frame(in: coordinateSpace).minY
    }
    
    private func stretchedHeight(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > 0 ? (startingHeight + offset) : startingHeight
    }
    
    private func strechedOffset(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > 0 ? -offset : 0
    }
}
