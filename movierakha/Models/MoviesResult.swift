//
//  MoviesResult.swift
//  movierakha
//
//  Created by Mohammad Rakha Mauludi on 05/04/22.
//

import Foundation

// MARK: - MoviesResult
struct MoviesResult: Codable {
    let page: Int?
    let results: [MovieData]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct MovieData: Codable {
    let backdropPath: String?
    let id: Int?
    let originalTitle: String?
    let overview, releaseDate, title: String?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case releaseDate = "release_date"
        case title
    }
}
