//
//  AppGroupCell.swift
//  AppStore
//
//  Created by user on 06.10.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String, font: UIFont) {
        self.init(frame: .zero)
        self.font = font
        self.text = text
    }
}

class AppsGroupCell: UICollectionViewCell {
    
    private let titleLabel: UILabel = .init(text: "App Section", font: .boldSystemFont(ofSize: 30))
    
    let horizontalController = AppsHorizontalController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        addSubview(horizontalController.view)
        horizontalController.view.backgroundColor = .blue
        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
