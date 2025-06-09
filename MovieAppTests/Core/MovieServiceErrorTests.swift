//
//  MovieServiceErrorTests.swift
//  MovieAppTests
//

import XCTest
@testable import MovieApp

final class MovieServiceErrorTests: XCTestCase {
    
    func testErrorDescription_invalidURL() {
        let error = MovieServiceError.invalidURL
        XCTAssertEqual(error.errorDescription, "Invalid URL.")
    }
    
    func testErrorDescription_networkError() {
        let underlyingError = NSError(domain: "TestDomain", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network failed"])
        let error = MovieServiceError.networkError(underlyingError)
        XCTAssertEqual(error.errorDescription, "Network error: Network failed")
    }
    
    func testErrorDescription_decodingError() {
        let underlyingError = NSError(domain: "TestDomain", code: -2, userInfo: [NSLocalizedDescriptionKey: "Decoding failed"])
        let error = MovieServiceError.decodingError(underlyingError)
        XCTAssertEqual(error.errorDescription, "Decoding error: Decoding failed")
    }
    
    func testErrorDescription_unknown() {
        let error = MovieServiceError.unknown
        XCTAssertEqual(error.errorDescription, "An unknown error occurred.")
    }
}
