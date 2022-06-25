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
	
	let closeButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "close_button"), for: .normal)
		button.tintColor = .darkGray
		button.addTarget(self, action: #selector(handleDismis), for: .touchUpInside)
		return button
	}()

	@objc func handleDismis() {
		dismiss(animated: true)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if mode == .fullscreen {
			setupCloseButton()
		} else {
			collectionView.isScrollEnabled = false
		}
		
		collectionView.backgroundColor = .white
		collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	override var prefersStatusBarHidden: Bool { return true }
	
	func setupCloseButton() {
		view.addSubview(closeButton)
		closeButton.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 20, left: 0, bottom: 0, right: 16), size: .init(width: 44, height: 44))
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		if mode == .fullscreen {
			return .init(top: 64, left: 24, bottom: 12, right: 24)
		}
		
		return .zero
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		if mode == .fullscreen {
			return results.count
		}
		
		return min(4, results.count)
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MultipleAppCell
		cell.app = results[indexPath.item]
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		// let height: CGFloat = (view.frame.height - 3 * spacing) / 4
		let height: CGFloat = 68
		
		if mode == .fullscreen {
			return .init(width: view.frame.width - 48, height: height)
		}
		
		return .init(width: view.frame.width, height: height)
	}
	
	let spacing: CGFloat = 16
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return spacing
	}
	
	let mode: Mode
	
	enum Mode {
		case small, fullscreen
	}
	
	init(mode: Mode) {
		self.mode = mode
		super.init()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
