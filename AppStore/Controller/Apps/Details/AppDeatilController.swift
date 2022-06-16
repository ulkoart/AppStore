//
//  AppDeatilController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 13.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class AppDeatilController: BaseListController, UICollectionViewDelegateFlowLayout {
	// https://itunes.apple.com/lookup?id=835599320
	

	var appId: String! {
		didSet {
			print("app ID: \(appId ?? "N/A")")
			let urlString = "https://itunes.apple.com/lookup?id=\(appId ?? "")"
			ServiceAPI.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, err) in
				let app = result?.results.first
				self.app = app
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
			}
		}
	}
	
	var app: Result?
	
	let detailCellId = "detailCellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
		navigationItem.largeTitleDisplayMode = .never
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 1
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
		cell.app = app
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// calc size
		let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
		dummyCell.app = app
		dummyCell.layoutIfNeeded()
		let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))

		return .init(width: view.frame.width, height: estimatedSize.height)
	}
}
