//
//  NetworkService.swift
//  MovieApp
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(url: URL) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// This generic function sends a GET request to the specified `URL`, and attempts to decode the response
    /// data into a specified type that conforms to `Decodable`.
    ///
    /// - Parameter url: The URL from which to fetch data.
    /// - Returns: A decoded object of type `T`
    func fetch<T: Decodable>(url: URL) async throws -> T {
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
