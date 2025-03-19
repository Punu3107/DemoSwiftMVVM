//
//  APIConstants.swift

import Foundation

struct APIConstants {
    static let host = "dog.ceo"
}

extension Request {
    var host: String {
        APIConstants.host
    }
}
