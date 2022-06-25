//
//  BackEnabledNavigationController.swift
//  AppStore
//
//  Created by Улько Артем Викторович on 25.06.2022.
//  Copyright © 2022 ulkoart. All rights reserved.
//

import UIKit

class BackEnabledNavigationController: UINavigationController, UIGestureRecognizerDelegate {
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.interactivePopGestureRecognizer?.delegate = self
	}
	
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		return self.viewControllers.count > 1
	}
}
