//
//  MusicController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 07.07.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class MusicController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	let cellId = "cellId"
	let footerId = "footerId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionView.backgroundColor = .white
		
		collectionView.register(TrackCell.self, forCellWithReuseIdentifier: cellId)
		collectionView.register(MusicLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
		
		fetchData()
	}
	
	var results = [ResultMusic]()
	let searchTerm = "taylor"
	var isPaginating = false
	var isDonePaginating = false
	
	private func fetchData() {
		let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=0&limit=20"
		
		ServiceAPI.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResultMusic?, err) in
			if let _ = err {
				print("fetchGenericJSONData error")
				return
			}
			
			if searchResult?.results.count == 0 {
				self.isDonePaginating = true
			}
			
			self.results = searchResult?.results ?? []
			
			DispatchQueue.main.async {
				self.collectionView.reloadData()
			}
		}
	}
	
	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
		return footer
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		let height: CGFloat = isDonePaginating ? 0 : 100
		return .init(width: view.frame.width, height: height)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		results.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrackCell
		
		let track = results[indexPath.item]
		cell.nameLabel.text = track.collectionName
		cell.subtitleLabel.text = track.artistName
		cell.imageView.sd_setImage(with: URL(string: track.artworkUrl100))
		
		if indexPath.item == results.count - 1 && !isPaginating{
			isPaginating = true
			let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&offset=\(results.count)&limit=20"
			
			ServiceAPI.shared.fetchGenericJSONData(urlString: urlString) { (searchResult: SearchResultMusic?, err) in
				if let _ = err {
					print("fetchGenericJSONData error")
					return
				}
				
				self.results += searchResult?.results ?? []
				
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
				self.isPaginating = false
			}
			
		}
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width, height: 100)
	}
	
}
