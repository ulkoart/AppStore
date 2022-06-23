//
//  AppFullScreenHeaderCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 23.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class AppFullScreenHeaderCell: UITableViewCell {
	
	let todayCell = TodayCell()
	
	let closeButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "close_button"), for: .normal)
		return button
	}()

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		addSubview(todayCell)
		todayCell.fillSuperview()
		
		addSubview(closeButton)
		closeButton.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 12), size: .init(width: 80, height: 30))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
