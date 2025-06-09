//
//  MovieListViewModelTests.swift
//  MovieAppTests
//

import XCTest
import SwiftData
@testable import MovieApp

final class MovieListViewModelTests: XCTestCase {
    
    func testLoadMoviesInitialLoadSuccess() async throws {
        let context = createInMemoryModelContext()
        let mockService = MockMovieService()
        
        mockService.fetchPopularMoviesResult = MovieResponse(
            page: 1,
            results: [
                MovieDTO(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: "path1")
            ],
            totalPages: 1,
            totalResults: 1
        )
        
        let sut = await MovieListViewModel(service: mockService, context: context)
        
        await sut.loadMovies()
        
        await MainActor.run {
            XCTAssertFalse(sut.isLoading)
            XCTAssertNil(sut.errorMessage)
            XCTAssertEqual(sut.movies.count, 1)
            XCTAssertEqual(sut.movies.first?.id, 1)
            XCTAssertFalse(sut.hasMorePages) // currentPage == 2 > totalPages == 1
        }
    }
    
    func testLoadMoviesPaginationStopsWhenNoMorePages() async throws {
        let context = createInMemoryModelContext()
        let mockService = MockMovieService()
        
        mockService.fetchPopularMoviesResult = MovieResponse(
            page: 1,
            results: [MovieDTO(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: "path1")],
            totalPages: 1,
            totalResults: 1
        )
        
        let sut = await MovieListViewModel(service: mockService, context: context)
        
        await sut.loadMovies() // loads page 1
        
        await MainActor.run{
            XCTAssertFalse(sut.hasMorePages)
        }
        
        await sut.loadMovies()
        await MainActor.run{
            XCTAssertFalse(sut.isLoading)
            XCTAssertEqual(sut.movies.count, 1)
        }
    }
    
    func testLoadMoviesIfNeededWithNilCurrentItemLoadsMovies() async throws {
        let context = createInMemoryModelContext()
        let mockService = MockMovieService()
        mockService.fetchPopularMoviesResult = MovieResponse(
            page: 1,
            results: [MovieDTO(id: 1, title: "Movie 1", overview: "Overview 1", posterPath: "path1")],
            totalPages: 2,
            totalResults: 2
        )
        let sut = await MovieListViewModel(service: mockService, context: context)
        
        await sut.loadMoviesIfNeeded(currentItem: nil)
        await MainActor.run {
            XCTAssertFalse(sut.isLoading)
            XCTAssertEqual(sut.movies.count, 1)
        }
    }
    
    func testLoadMoviesIfNeededAtThresholdLoadsMovies() async throws {
        let context = createInMemoryModelContext()
        let mockService = MockMovieService()
        mockService.fetchPopularMoviesResult = MovieResponse(
            page: 1,
            results: (1...6).map {
                MovieDTO(id: $0, title: "Movie \($0)", overview: "Overview \($0)", posterPath: "path\($0)")
            },
            totalPages: 2,
            totalResults: 12
        )
        
        let sut = await MovieListViewModel(service: mockService, context: context)
        await sut.loadMovies()
        
        // threshold index = endIndex - 5 = 6 - 5 = 1 (0-based)
        await MainActor.run {
            let thresholdMovie = sut.movies[1]
            Task {
                // Trigger loadMoviesIfNeeded on threshold movie
                await sut.loadMoviesIfNeeded(currentItem: thresholdMovie)
            }
            XCTAssertFalse(sut.isLoading)
            XCTAssertEqual(sut.movies.count, 6)
            XCTAssertTrue(sut.hasMorePages)
        }
    }
    
    func testLoadMoviesDoesNotLoadWhenIsLoadingTrue() async throws {
        let context = createInMemoryModelContext()
        let mockService = MockMovieService()
        
        let sut = await MovieListViewModel(service: mockService, context: context)
        await MainActor.run {
            sut.isLoading = true
        }
        
        await sut.loadMovies()
        
        await MainActor.run {
            XCTAssertTrue(sut.isLoading)
            XCTAssertEqual(sut.movies.count, 0)
        }
    }
    
    func testLoadMoviesErrorFallbackLoadsCache() async throws {
        let context = createInMemoryModelContext()
        let mockService = MockMovieService()
        mockService.shouldThrowError = true
        mockService.errorToThrow = MovieServiceError.networkError(URLError(.timedOut))
        
        let cachedMovie = MovieModel(id: 99, title: "Cached Movie", overview: "Cached overview", posterPath: nil)
        context.insert(cachedMovie)
        
        let sut = await MovieListViewModel(service: mockService, context: context)
        
        await sut.loadMovies()
        
        await MainActor.run {
            XCTAssertEqual(sut.movies.count, 1)
            XCTAssertEqual(sut.movies.first?.id, 99)
            XCTAssertNotNil(sut.errorMessage)
            XCTAssertFalse(sut.isLoading)
        }
    }
    
    func testLoadMovies_FailureWithGenericError() async throws {
        let context = createInMemoryModelContext()
        let mockMovieService = MockMovieService()
        mockMovieService.shouldThrowError = true
        mockMovieService.errorToThrow = MovieServiceError.unknown
        
        let sut = await MovieListViewModel(service: mockMovieService, context: context)
        
        await sut.loadMovies()
        
        await MainActor.run {
            XCTAssertEqual(sut.errorMessage, "An unknown error occurred.")
        }
    }
    
}
