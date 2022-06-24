//
//  TodayMultipleAppCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 24.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class TodayMultipleAppCell: BaseTodayCell {

	override var todayItem: TodayItem! {
		didSet {
			categoryLabel.text = todayItem.catecory
			titleLabel.text = todayItem.title
		}
	}

	let categoryLabel = UILabel(text: "LIFE HACK", font: .boldSystemFont(ofSize: 20))
	let titleLabel = UILabel(text: "Utilizing your Time", font: .boldSystemFont(ofSize: 32), numberOfLines: 2)

	let multipleAppsController = TodayMultipleAppsController()

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .white
		layer.cornerRadius = 16
		
		let stackView = VerticalStackView(arrangedSubviews: [
			categoryLabel,
			titleLabel,
			multipleAppsController.view
		], spacing: 12)
		
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 24, left: 24, bottom: 24, right: 24))
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
