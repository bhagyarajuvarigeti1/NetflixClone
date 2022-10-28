//
//  Movie.swift
//  Netflix Clone
//
//  Created by mac on 26/10/22.
//

import Foundation

struct TrendingMovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id : Int
    let mediaType : String?
    let originalName: String?
    let originalTitle: String?
    let posterPath: String?
    let overview: String?
    let voteCount: Int
    let releaseDate: String?
    let voteAverage: Double
}
