//
//  View+Extension.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/24/24.
//

import Foundation
import SwiftUI

extension View {
    func SpacedText(_ value: String) -> some View {
        HStack {
            Text(value)
            Spacer()
        }
    }
}
