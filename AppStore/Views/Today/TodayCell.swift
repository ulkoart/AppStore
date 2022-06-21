//
//  TodayCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 21.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
	
	let imageView = UIImageView(image: UIImage(named: "garden"))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		layer.cornerRadius = 16
		
		addSubview(imageView)
		imageView.contentMode = .scaleAspectFill
		imageView.centerInSuperview(size: .init(width: 280, height: 200))
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
