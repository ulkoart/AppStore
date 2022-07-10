//
//  AppGroup.swift
//  AppStore
//
//  Created by user on 08.10.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable, Hashable {
    let id, name, artistName, artworkUrl100: String
}
