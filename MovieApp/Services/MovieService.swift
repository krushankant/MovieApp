//
//  MovieService.swift
//  MovieApp
//

import Foundation

protocol MovieServiceProtocol {
    func fetchPopularMovies(page: Int) async throws -> MovieResponse
}

final class MovieService: MovieServiceProtocol {
    private let network: NetworkServiceProtocol
    
    init(network: NetworkServiceProtocol = NetworkService()) {
        self.network = network
    }
    
    /// This function fetches a list of popular movies from the API.
    /// - Parameter page: The page number of results to fetch. Starts at 1
    /// - Returns: A MovieResponse containing the list of popular movies for the specified page.
    func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        let urlString = "\(APIConstants.baseURL)/movie/popular?api_key=\(APIConstants.apiKey)&language=\(APIConstants.defaultLanguage)&page=\(page)"
        print("urlString:\(urlString)")
        
        guard let url = URL(string: urlString) else {
            throw MovieServiceError.invalidURL
        }
        
        do {
            return try await network.fetch(url: url)
        } catch let decodingError as DecodingError {
            throw MovieServiceError.decodingError(decodingError)
        } catch {
            throw MovieServiceError.networkError(error)
        }
    }
}

