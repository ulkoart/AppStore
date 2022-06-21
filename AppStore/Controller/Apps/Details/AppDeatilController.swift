//
//  AppDeatilController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 13.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

final class AppDetailController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	private let appId: String
	
	init(appId: String) {
		self.appId = appId
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	var app: Result?
	var reviews: Reviews?
	
	let detailCellId = "detailCellId"
	let previewCellId = "previewCellId"
	let reviewCellId = "reviewCellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		
		collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: detailCellId)
		collectionView.register(PreviewCell.self, forCellWithReuseIdentifier: previewCellId)
		collectionView.register(ReviewRowCell.self, forCellWithReuseIdentifier: reviewCellId)
		
		navigationItem.largeTitleDisplayMode = .never
		
		fetchData()
	}
	
	private func fetchData() {
		let urlString = "https://itunes.apple.com/lookup?id=\(appId)"
		ServiceAPI.shared.fetchGenericJSONData(urlString: urlString) { (result: SearchResult?, err) in
			let app = result?.results.first
			self.app = app
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
		
		let reviewsUrl = "https://itunes.apple.com/rss/customerreviews/page=1/id=\(appId)/sortby=mostrecent/json?l=en&cc=us"
		print(reviewsUrl)
		ServiceAPI.shared.fetchGenericJSONData(urlString: reviewsUrl) { (reviews:Reviews?, err) in
			if let err = err {
				print(err)
				return
			}
			self.reviews = reviews
			// reviews?.feed.entry.forEach { print($0.rating.label) }
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 3
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		if indexPath.item == 0 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailCellId, for: indexPath) as! AppDetailCell
			cell.app = app
			return cell
		} else if indexPath.item == 1 {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: previewCellId, for: indexPath) as! PreviewCell
			cell.horizontalController.app = self.app
			return cell
		} else {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellId, for: indexPath) as! ReviewRowCell
			cell.reviewsController.reviews = self.reviews
			return cell
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		var height: CGFloat = 280
		
		if indexPath.item == 0 {
			// calculate the necessary size for our cell somehow
			let dummyCell = AppDetailCell(frame: .init(x: 0, y: 0, width: view.frame.width, height: 1000))
			dummyCell.app = app
			dummyCell.layoutIfNeeded()
			
			let estimatedSize = dummyCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
			height = estimatedSize.height
		} else if indexPath.item == 1 {
			height = 500
		} else {
			height = 280
		}
		return .init(width: view.frame.width, height: height)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 0, left: 0, bottom: 16, right: 0)
	}
}

