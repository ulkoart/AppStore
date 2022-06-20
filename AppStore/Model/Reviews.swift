//
//  Reviews.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 20.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import Foundation

struct Reviews: Decodable {
	let feed: ReviewFeed
}

struct ReviewFeed: Decodable {
	let entry: [Entry]
}

struct Entry: Decodable {
	let author: Author
	let title: Label
	let content: Label
}

struct Author: Decodable {
	let name: Label
}

struct Label: Decodable {
	let label: String
}


