//
//  TodayItem.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 23.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import Foundation
import UIKit

struct TodayItem {
	let catecory: String
	let title: String
	let image: UIImage
	let description: String
	let backgroundColor: UIColor
	
	// enum
	let cellType: CellType
	
	let apps: [FeedResult]
	
	enum CellType: String {
		case signle, multiple
	}
}
