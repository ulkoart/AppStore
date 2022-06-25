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
		

		dispatchGroup.notify(queue: .main) {
			print("finish")
			self.collectionView.reloadData()
			self.items = [
				TodayItem(catecory: "THE DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: UIImage(named: "garden")!, description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
				TodayItem(catecory: "FILE HACK", title: "Utilizing your Time", image: UIImage(named: "garden")!, description: "All the tools and apps you need to intelligenty orgznize your live to right way.", backgroundColor: .white, cellType: .signle, apps: []),
				TodayItem(catecory: "HOLIDAYS", title: "Travel on a Budget", image: UIImage(named: "holiday")!, description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: #colorLiteral(red: 0.9838578105, green: 0.9588007331, blue: 0.7274674177, alpha: 1), cellType: .signle, apps: [])
			]
			self.activityIndicator.stopAnimating()
		}
	}
	
	var appFullscreenController: AppFullscreenController!
	
	var topConstraint: NSLayoutConstraint?
	var leadingConstraint: NSLayoutConstraint?
	var widthConstraint: NSLayoutConstraint?
	var heightConstraint: NSLayoutConstraint?
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		if items[indexPath.item].cellType == .multiple {
			let fullController = TodayMultipleAppsController(mode: .fullscreen)
			fullController.apps = self.items[indexPath.item].apps
			fullController.modalPresentationStyle = .fullScreen
			let navigationController = BackEnabledNavigationController(rootViewController: fullController)
			navigationController.modalPresentationStyle = .fullScreen
			present(navigationController, animated: true)
			return
		}
		
		let appFullscreenController = AppFullscreenController()
		appFullscreenController.todayItem = items[indexPath.row]
		appFullscreenController.dismissHandler = {
			self.handleRemoveRedView()
		}
		let fullscreenView = appFullscreenController.view!

		view.addSubview(fullscreenView)

		addChild(appFullscreenController)
		
		self.appFullscreenController = appFullscreenController
		self.collectionView.isUserInteractionEnabled = false
		
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		// absolute coordindates of cell
		guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
		
		self.startingFrame = startingFrame

		// auto layout constraint animations
		// 4 anchors
		fullscreenView.translatesAutoresizingMaskIntoConstraints = false
		topConstraint = fullscreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
		leadingConstraint = fullscreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
		widthConstraint = fullscreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
		heightConstraint = fullscreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
		
		[topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach({$0?.isActive = true})
		self.view.layoutIfNeeded()
		
		fullscreenView.layer.cornerRadius = 16
		
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

			self.topConstraint?.constant = 0
			self.leadingConstraint?.constant = 0
			self.widthConstraint?.constant = self.view.frame.width
			self.heightConstraint?.constant = self.view.frame.height
			
			self.view.layoutIfNeeded() // starts animation

			self.tabBarController?.tabBar.frame.origin.y += 100 // self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
			
			guard let cell = appFullscreenController.tableView.cellForRow(at: [0,0]) as? AppFullscreenHeaderCell else { return }
			cell.todayCell.topConstraint.constant = 48
			cell.layoutIfNeeded()

		}, completion: nil)
	}
	
	var startingFrame: CGRect?
	
	@objc func handleRemoveRedView() {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			
			self.appFullscreenController.tableView.contentOffset = .zero
			
			guard let startingFrame = self.startingFrame else { return }
			self.topConstraint?.constant = startingFrame.origin.y
			self.leadingConstraint?.constant = startingFrame.origin.x
			self.widthConstraint?.constant = startingFrame.width
			self.heightConstraint?.constant = startingFrame.height
			
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

