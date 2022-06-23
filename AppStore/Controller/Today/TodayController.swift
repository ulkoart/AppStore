//
//  TodayController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 21.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
	
	private let cellId = "cellId"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationController?.isNavigationBarHidden = true
		
		collectionView.backgroundColor = #colorLiteral(red: 0.948936522, green: 0.9490727782, blue: 0.9489068389, alpha: 1)
		
		collectionView.register(TodayCell.self, forCellWithReuseIdentifier: cellId)
	}
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 4
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
		return cell
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return .init(width: view.frame.width - 64, height: 450)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 32
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return .init(top: 32, left: 0, bottom: 32, right: 0)
	}
	
	var appFullScreenController: AppFullScreenController!

	var topConstraint: NSLayoutConstraint?
	var leadingConstraint: NSLayoutConstraint?
	var widthConstraint: NSLayoutConstraint?
	var heightConstraint: NSLayoutConstraint?
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let appFullScreenController = AppFullScreenController()
		let redView = appFullScreenController.view!
		redView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView)))
		view.addSubview(redView)
		addChild(appFullScreenController)
		self.appFullScreenController = appFullScreenController
		
		guard let cell = collectionView.cellForItem(at: indexPath) else { return }
		
		guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
		self.startingFrame = startingFrame
		// redView.frame = startingFrame
		
		redView.translatesAutoresizingMaskIntoConstraints = false
		self.topConstraint = redView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
		self.leadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: startingFrame.origin.x)
		self.widthConstraint = redView.widthAnchor.constraint(equalToConstant: startingFrame.width)
		self.heightConstraint = redView.heightAnchor.constraint(equalToConstant: startingFrame.height)
		
		[topConstraint, leadingConstraint, widthConstraint, heightConstraint].forEach { $0?.isActive = true }
		self.view.layoutIfNeeded()
		
		redView.layer.cornerRadius = 16 // ?
		
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			// redView.frame = self.view.frame
			
			self.topConstraint?.constant = 0
			self.leadingConstraint?.constant = 0
			self.widthConstraint?.constant = self.view.frame.width
			self.heightConstraint?.constant = self.view.frame.height
			self.view.layoutIfNeeded()

			self.tabBarController?.tabBar.frame.origin.y += 100  // self.tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
		}, completion: nil)
	}
	
	var startingFrame: CGRect?
	
	@objc private func handleRemoveRedView(gesture: UIPanGestureRecognizer) {
		UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
			
			guard let startingFrame = self.startingFrame else {
				return
			}
			
			//self.appFullScreenController.tableView.scrollToRow(at: [0, 0], at: .top, animated: true)
			self.appFullScreenController.tableView.contentOffset = .zero
			
			self.topConstraint?.constant = startingFrame.origin.y
			self.leadingConstraint?.constant = startingFrame.origin.x
			self.widthConstraint?.constant = startingFrame.width
			self.heightConstraint?.constant = startingFrame.height
			self.view.layoutIfNeeded()

			// bad
			// gesture.view?.frame = self.startingFrame ?? .zero
			self.tabBarController?.tabBar.frame.origin.y -= 100
		}, completion: { _ in
			gesture.view?.removeFromSuperview()
			self.appFullScreenController.removeFromParent()
		})
	}
}
