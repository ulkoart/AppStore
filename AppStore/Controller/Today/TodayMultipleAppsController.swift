//
//  TodayMultipleAppsController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 24.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class TodayMultipleAppsController: BaseListController, UICollectionViewDelegateFlowLayout {
	let cellId = "cellId"
	
	var results = [FeedResult]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.backgroundColor = .white
		collectionView.isScrollEnabled = false
		collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
		
		ServiceAPI.shared.fetchTopGrossing { [weak self] (appGroup, err) in
			self?.results = appGroup?.feed.results ?? []

			DispatchQueue.main.async {
				self?.collectionView.reloadData()
			}
			
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return min(4, results.count)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
		cell.app = results[indexPath.item]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		
		let height: CGFloat = (view.frame.height - 3 * spacing) / 4
		
		return .init(width: view.frame.width, height: height)
	}
	
	let spacing: CGFloat = 16
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}
}
