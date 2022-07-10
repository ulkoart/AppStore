//
//  AppRowCell.swift
//  AppStore
//
//  Created by user on 06.10.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

class AppRowCell: UICollectionViewCell {
	
	var app: FeedResult! {
		didSet {
			companyLabel.text = app.name
			nameLabel.text = app.name
			imageView.sd_setImage(with: URL(string: app.artworkUrl100))
		}
	}
    
    let imageView: UIImageView = UIImageView(cornerRadius: 8)
    let nameLabel = UILabel(text: "App Name", font: .systemFont(ofSize: 20))
    let companyLabel = UILabel(text: "Company Name", font: .systemFont(ofSize: 12))
    let getButton = UIButton(title: "GET")

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.backgroundColor = .purple
        imageView.constrainWidth(constant: 64)
        imageView.constrainHeight(constant: 64)
        
        getButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        getButton.constrainWidth(constant: 80)
        getButton.constrainHeight(constant:32)
        getButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        getButton.layer.cornerRadius = 32/2

        let stackView = UIStackView(arrangedSubviews: [imageView, VerticalStackView(arrangedSubviews: [nameLabel, companyLabel]), getButton])
        stackView.spacing = 16
        
        stackView.alignment = .center
        
        addSubview(stackView)
        stackView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
