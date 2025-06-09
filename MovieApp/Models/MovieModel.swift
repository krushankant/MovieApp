//
//  MovieModel.swift
//  MovieApp
//

import Foundation
import SwiftData

@Model
final class MovieModel: Identifiable {
    @Attribute(.unique) var id: Int
    var title: String
    var overview: String
    var posterPath: String?

    init(id: Int, title: String, overview: String, posterPath: String?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
    }

    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
}

// MARK: - Mapping between DTO and Model
extension MovieModel {
    var asDTO: MovieDTO {
        MovieDTO(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath
        )
    }

    static func from(dto: MovieDTO) -> MovieModel {
        MovieModel(
            id: dto.id,
            title: dto.title,
            overview: dto.overview,
            posterPath: dto.posterPath
        )
    }
}


