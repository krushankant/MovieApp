//
//  MovieDTO.swift
//  MovieApp
//

import Foundation

struct MovieDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
    }
}
