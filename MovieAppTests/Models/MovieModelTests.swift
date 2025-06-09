//
//  MovieModelTests.swift
//  MovieAppTests
//

import XCTest
@testable import MovieApp

final class MovieModelTests: XCTestCase {
    
    func testMovieModelInitializationFromDTO() {
        let dto = MovieDTO(id: 1, title: "Inception", overview: "A dream within a dream", posterPath: "/inception.jpg")
        let model = MovieModel.from(dto: dto)
        
        XCTAssertEqual(model.id, dto.id)
        XCTAssertEqual(model.title, dto.title)
        XCTAssertEqual(model.overview, dto.overview)
        XCTAssertEqual(model.posterPath, dto.posterPath)
    }
    
    func testMovieDTOConversionFromModel() {
        let model = MovieModel(id: 2, title: "Interstellar", overview: "Space exploration", posterPath: "/interstellar.jpg")
        let dto = model.asDTO
        
        XCTAssertEqual(dto.id, model.id)
        XCTAssertEqual(dto.title, model.title)
        XCTAssertEqual(dto.overview, model.overview)
        XCTAssertEqual(dto.posterPath, model.posterPath)
    }
    
    func testPosterURLGeneration() {
        let model = MovieModel(id: 3, title: "Dune", overview: "Arrakis", posterPath: "/dune.jpg")
        
        let expectedURL = URL(string: "https://image.tmdb.org/t/p/w500/dune.jpg")
        XCTAssertEqual(model.posterURL, expectedURL)
    }
    
    func testPosterURLIsNilWhenPathIsNil() {
        let model = MovieModel(id: 4, title: "No Image", overview: "Missing poster", posterPath: nil)
        XCTAssertNil(model.posterURL)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
