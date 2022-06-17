//
//  ReviewRowCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 17.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
	
	let reviewsController = ReviewsController()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .yellow
		
		addSubview(reviewsController.view)
		reviewsController.view.fillSuperview()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
}
