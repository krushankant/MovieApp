//
//  MockMovieService.swift
//  MovieApp
//

import Foundation
@testable import MovieApp

final class MockMovieService: MovieServiceProtocol {
    var shouldThrowError = false
    var fetchPopularMoviesResult: MovieResponse = MovieResponse(
        page: 1,
        results: [],
        totalPages: 1,
        totalResults: 0
    )
    var errorToThrow: Error = MovieServiceError.unknown

    func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        if shouldThrowError {
            throw errorToThrow
        }
        return fetchPopularMoviesResult
    }
}

