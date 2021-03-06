//
//  TodayCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 21.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class TodayCell: BaseTodayCell {
	
	override var todayItem: TodayItem! {
		didSet {
			categoryLabel.text = todayItem.catecory
			titleLabel.text = todayItem.title
			imageView.image = todayItem.image
			descriptionLabel.text = todayItem.description
			backgroundColor = todayItem.backgroundColor
			backgroundView?.backgroundColor = todayItem.backgroundColor
		}
	}
	
	let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
	let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 26))
	
	let imageView = UIImageView(image: UIImage(named: "garden"))
	
	let descriptionLabel = UILabel(text: "All the tools and apps you need to intelligenty orgznize your live to right way.", font: .systemFont(ofSize: 16), numberOfLines: 3)
	
	var topConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		// clipsToBounds = true
		layer.cornerRadius = 16

		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		
		let imageContainerView = UIView()
		imageContainerView.addSubview(imageView)
		imageView.centerInSuperview(size: .init(width: 240, height: 240))
		let stackView = VerticalStackView(arrangedSubviews: [
			categoryLabel, titleLabel, imageContainerView, descriptionLabel
		], spacing: 8)
		addSubview(stackView)
		stackView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 24, left: 24, bottom: 24, right: 24))
		self.topConstraint = stackView.topAnchor.constraint(equalTo: topAnchor, constant: 48)
		self.topConstraint.isActive = true
		// stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
