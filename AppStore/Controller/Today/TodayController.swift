//
//  TodayController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 21.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	var items = [TodayItem]()
	var startingFrame: CGRect?
	var anchoredConstraint: AnchoredConstraints?
	var appFullscreenController: AppFullscreenController!
	
	let activityIndicator: UIActivityIndicatorView = {
		let avi = UIActivityIndicatorView(style: .whiteLarge)
		avi.color = .darkGray
		avi.hidesWhenStopped = true
		return avi
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(activityIndicator)
		activityIndicator.centerInSuperview()
		activityIndicator.startAnimating()
		
		fetchData()
		
		navigationController?.isNavigationBarHidden = true
		
		collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
		
		collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.signle.rawValue)
		collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
		
	}
	
	func fetchData() {
		let dispatchGroup = DispatchGroup()
		var topGrossingGroup: AppGroup?
		var gamesGroup: AppGroup?
		
		dispatchGroup.enter()
		ServiceAPI.shared.fetchTopGrossing { (appGroup, err) in
			topGrossingGroup = appGroup
			dispatchGroup.leave()
		}
		
		dispatchGroup.enter()
		ServiceAPI.shared.fetchGames { (appGroup, err) in
			gamesGroup = appGroup
			dispatchGroup.leave()
		}
		
		self.activityIndicator.stopAnimating()
		dispatchGroup.notify(queue: .main) {
			print("finish")
			self.collectionView.reloadData()
			self.items = [
				TodayItem(catecory: "THE DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: UIImage(named: "garden")!, description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
				TodayItem(catecory: "FILE HACK", title: "Utilizing your Time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligenty orgznize your live to right way.", backgroundColor: .white, cellType: .signle, apps: []),
				TodayItem(catecory: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .signle, apps: [])
			]
			
		}
	}
			
	fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
		let fullController = TodayMultipleAppsController(mode: .fullscreen)
		fullController.apps = self.items[indexPath.item].apps
		fullController.modalPresentationStyle = .fullScreen
		let navigationController = BackEnabledNavigationController(rootViewController: fullController)
		navigationController.modalPresentationStyle = .fullScreen
		present(navigationController, animated: true)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		switch items[indexPath.item].cellType {
		case .signle:
			showSingleAppFullScreen(indexPath: indexPath)
		case .multiple:
			showDailyListFullScreen(indexPath)
		}
	}
	
	fileprivate func setupSingleAppFullscreenController(_ indexPath: IndexPath) {
		let appFullscreenController = AppFullscreenController()
		appFullscreenController.todayItem = items[indexPath.row]
		appFullscreenController.dismissHandler = {
			self.handleRemoveRedView()
		}
		appFullscreenController.view.layer.cornerRadius = 16
		self.appFullscreenController = appFullscreenController
	}
	
	fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
		self.startingFrame = startingFrame
	}
	
	fileprivate func setupAppFullscreenStartingPosition(_ indexPath: IndexPath) {
		let fullscreenView = appFullscreenController.view!
		view.addSubview(fullscreenView)
		addChild(appFullscreenController)
		self.collectionView.isUserInteractionEnabled = false
		
		setupStartingCellFrame(indexPath)
		
		guard let startingFrame = self.startingFrame else { return }
		
		self.anchoredConstraint = fullscreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))

		self.view.layoutIfNeeded()
	}
	
	fileprivate func beginAnimationAppFullscreen () {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			
			self.anchoredConstraint?.top?.constant = 0
			self.anchoredConstraint?.leading?.constant = 0
			self.anchoredConstraint?.width?.constant = self.view.frame.width
			self.anchoredConstraint?.height?.constant = self.view.frame.height
			
			self.view.layoutIfNeeded() // starts animation
			
			self.tabBarController?.tabBar.frame.origin.y += 100 // self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
			
			guard let cell = self.appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
			cell.todayCell.topConstraint.constant = 48
			cell.layoutIfNeeded()
			
		}, completion: nil)
	}
	
	fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
		// # 1
		setupSingleAppFullscreenController(indexPath)
		
		// # 2
		setupAppFullscreenStartingPosition(indexPath)
		
		// # 3
		beginAnimationAppFullscreen()

	}

	
	@objc func handleRemoveRedView() {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			
			self.appFullscreenController.tableView.contentOffset = .zero
			
			guard let startingFrame = self.startingFrame else { return }
			
			self.anchoredConstraint?.top?.constant = startingFrame.origin.y
			self.anchoredConstraint?.leading?.constant = startingFrame.origin.x
			self.anchoredConstraint?.width?.constant = startingFrame.width
			self.anchoredConstraint?.height?.constant = startingFrame.height

			self.view.layoutIfNeeded()
			
			// self.tabBarController?.tabBar.transform = .identity
			self.tabBarController?.tabBar.frame.origin.y -= 100
			
		}, completion: { _ in
			self.appFullscreenController.view.removeFromSuperview()
			self.appFullscreenController.removeFromParent()
			self.collectionView.isUserInteractionEnabled = true
		})
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return items.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cellId = items[indexPath.item].cellType.rawValue
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
		cell.todayItem = items[indexPath.item]
		
		(cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
		
		return cell
	}
	
	@objc func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
		
		let collectionView = gesture.view
		var superview = collectionView?.superview
		
		while superview != nil {
			if let cell = superview as? TodayMultipleAppCell {
				guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
				let apps = self.items[indexPath.item].apps
				
				let fullController = TodayMultipleAppsController(mode: .fullscreen)
				fullController.apps = apps
				present(fullController, animated: true, completion: nil)
			}
			
			superview = superview?.superview
		}
		
		
	}
	
	static let cellSize: CGFloat = 500
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width - 64, height: TodayController.cellSize)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 32
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 32, left: 0, bottom: 32, right: 0)
	}
	
}

