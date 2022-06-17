//
//  ReviewCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 17.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class ReviewCell: UICollectionViewCell {
	
	let titleLabel = UILabel(text: "Review Title", font: .boldSystemFont(ofSize: 18))
	
	let authorLabel = UILabel(text: "Author", font: .systemFont(ofSize: 16))
	
	let starsLabel = UILabel(text: "Stars", font: .systemFont(ofSize: 14))
	
	let bodyLabel = UILabel(text: "Review body\nReview body\nReview body\n", font: .systemFont(ofSize: 16), numberOfLines: 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = #colorLiteral(red: 0.9423103929, green: 0.9410001636, blue: 0.9745038152, alpha: 1)
		layer.cornerRadius = 16
		clipsToBounds = true
		
		let stackView = VerticalStackView(arrangedSubviews: [
			UIStackView(arrangedSubviews: [
				titleLabel, UIView(), authorLabel
				]),
			starsLabel,
			bodyLabel
			], spacing: 12)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError()
	}
	
}
