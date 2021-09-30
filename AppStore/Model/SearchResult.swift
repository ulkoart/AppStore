//
//  SearchResult.swift
//  AppStore
//
//  Created by user on 30.09.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
    let averageUserRating: Float?
}
