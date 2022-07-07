//
//  MusicLoadingFooter.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 07.07.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class MusicLoadingFooter: UICollectionReusableView {

	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let avi = UIActivityIndicatorView(style: .large)
		avi.color = .darkGray
		avi.startAnimating()
		let label = UILabel(text: "Loading more...", font: .systemFont(ofSize: 16))
		label.textAlignment = .center
		
		let stackView = VerticalStackView(arrangedSubviews: [avi, label], spacing: 8)
		addSubview(stackView)
		stackView.centerInSuperview(size: .init(width: 200, height: 0))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
