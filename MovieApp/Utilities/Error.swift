//
//  Error.swift
//  MovieApp
//

import Foundation

/// MARK: - MovieServiceError
enum MovieServiceError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
