//
//  URLResponse.swift
//  SmartMovie
//
//  Created by Taewon Yoon on 6/12/24.
//

import Foundation

extension URLResponse {

    private var successCodeRange: ClosedRange<Int> {
        return 200...299
    }

    var isValidResponse: Bool {
        guard let responseCode = self as? HTTPURLResponse else { return false }
        guard successCodeRange.contains(responseCode.statusCode) else { return false }

        return true
    }

}
