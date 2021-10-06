//
//  BaseListController.swift
//  AppStore
//
//  Created by user on 06.10.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

class BaseListController: UICollectionViewController {
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
