//
//  MovieServiceTests.swift
//  MovieAppTests
//

import XCTest
@testable import MovieApp

final class MovieServiceTests: XCTestCase {
    
    func testFetchPopularMoviesSuccess() async throws {
        let movieDTO = MovieDTO(
            id: 1,
            title: "Lilo & Stitch",
            overview: "A fun Disney movie.",
            posterPath: "/path_to_poster.jpg"
        )
        
        let mockResponse = MovieResponse(
            page: 1,
            results: [movieDTO],
            totalPages: 1,
            totalResults: 1
        )
        
        let mockMovieService = MockMovieService()
        mockMovieService.shouldThrowError = false
        mockMovieService.fetchPopularMoviesResult = mockResponse
        
        let response = try await mockMovieService.fetchPopularMovies(page: 1)
        
        XCTAssertFalse(response.results.isEmpty, "Expected movies list to be non-empty")
        XCTAssertEqual(response.results.first?.title, "Lilo & Stitch", "Expected first movie title to match")
    }
    
    
    func testFetchPopularMoviesDecodingError() async throws {
        let mockMovieService = MockMovieService()
        mockMovieService.shouldThrowError = true
        mockMovieService.errorToThrow = MovieServiceError.decodingError(
            DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "Test decoding error")
            )
        )
        
        do {
            _ = try await mockMovieService.fetchPopularMovies(page: 1)
            XCTFail("Expected decoding error to be thrown")
        } catch let error as MovieServiceError {
            switch error {
            case .decodingError:
                XCTAssertTrue(true)
            default:
                XCTFail("Expected decodingError, got \(error)")
            }
        } catch {
            XCTFail("Expected MovieServiceError, got \(error)")
        }
    }
    
    
    // MARK: - Negative Test Case: Network Error
    func testFetchPopularMoviesNetworkError() async throws {
        let mockMovieService = MockMovieService()
        mockMovieService.shouldThrowError = true
        mockMovieService.errorToThrow = MovieServiceError.networkError(URLError(.timedOut))
        
        do {
            _ = try await mockMovieService.fetchPopularMovies(page: 1)
            XCTFail("Expected network error to be thrown")
        } catch let error as MovieServiceError {
            switch error {
            case .networkError:
                XCTAssertTrue(true) // Success: network error thrown
            default:
                XCTFail("Expected networkError, got \(error)")
            }
        } catch {
            XCTFail("Expected MovieServiceError, got \(error)")
        }
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
