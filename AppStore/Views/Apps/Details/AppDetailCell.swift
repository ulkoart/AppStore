//
//  AppDetailCell.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 13.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
	
	var app: Result! {
		didSet {
			nameLabel.text = app?.trackName
			releaseNoteslabel.text = app?.releaseNotes
			appIconImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
			priceButton.setTitle(app?.formattedPrice, for: .normal)
		}
	}
	
	let appIconImageView = UIImageView(cornerRadius: 16)
	let nameLabel = UILabel(text: "App Name", font: .boldSystemFont(ofSize: 24), numberOfLines: 2)
	let priceButton = UIButton(title: "$4.99")
	let whatsNewLabel = UILabel(text: "What`s New", font: .boldSystemFont(ofSize: 20))
	let releaseNoteslabel = UILabel(text: "Release Notes", font: .systemFont(ofSize: 16), numberOfLines: 0)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		appIconImageView.backgroundColor = .systemGray
		appIconImageView.constrainWidth(constant: 140)
		appIconImageView.constrainHeight(constant: 140)
		
		priceButton.backgroundColor = .blue
		priceButton.constrainHeight(constant: 32)
		priceButton.layer.cornerRadius = 32 / 2
		priceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
		priceButton.setTitleColor(.white, for: .normal)
		priceButton.constrainWidth(constant: 80)
		
		let stackView = VerticalStackView(arrangedSubviews: [
		UIStackView(arrangedSubviews: [
			appIconImageView,
			VerticalStackView(arrangedSubviews: [
				nameLabel,
				UIStackView(arrangedSubviews: [priceButton, UIView()]),
				UIView()
			], spacing: 12)
		], customSpacing: 20),
		whatsNewLabel,
		releaseNoteslabel
		], spacing: 16)
		addSubview(stackView)
		stackView.fillSuperview(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
