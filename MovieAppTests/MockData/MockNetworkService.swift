//
//  MockNetworkService.swift
//  MovieApp
//

import Foundation
@testable import MovieApp

final class MockNetworkService: NetworkServiceProtocol {
    var shouldThrowError: Bool = false
    var mockError: Error = URLError(.badServerResponse)
    var mockFileName: String = "popularMovies" // You can override this if needed

    func fetch<T: Decodable>(url: URL) async throws -> T {
        if shouldThrowError {
            throw mockError
        }

        // Use test bundle for loading the JSON file
        let bundle = Bundle(for: type(of: self))
        guard let fileURL = bundle.url(forResource: mockFileName, withExtension: "json") else {
            throw MovieServiceError.unknown
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw MovieServiceError.decodingError(error)
        }
    }
}


