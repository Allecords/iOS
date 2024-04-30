//
//  HomeTabBuilder.swift
//  Allecords
//
//  Created by Hoon on 4/30/24.
//

import AllecordsNetwork
import UIKit

protocol HomeTabBuilderProtocol {
	func build() -> UIViewController
}

struct HomeTabBuilder: HomeTabBuilderProtocol {
	func build() -> UIViewController {
		let homeTabRouter = HomeTabRouter()
		let betweenBuilder = BetweenBuilder()
		let homeTabController = HomeTabViewController(
			router: homeTabRouter,
			betweenBuilder: betweenBuilder
		)
		let homeTabNavController = UINavigationController(rootViewController: homeTabController)
		homeTabNavController.isNavigationBarHidden = true
		homeTabNavController.interactivePopGestureRecognizer?.isEnabled = true
		homeTabRouter.viewController = homeTabNavController
		return homeTabNavController
	}
}
