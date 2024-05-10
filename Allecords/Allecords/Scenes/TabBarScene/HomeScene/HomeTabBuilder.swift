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
    let productDetailBuilder = ProductDetailBuilder()
    let betweenRouter = BetweenRouter(productDetailBuilder: productDetailBuilder)
    let allecordsRouter = AllecordsRouter(productDetailBuilder: productDetailBuilder)
		let betweenBuilder = BetweenBuilder()
    let allecordsBuilder = AllecordsBuilder()
		let homeTabController = HomeTabViewController(
			router: homeTabRouter,
      betweenRouter: betweenRouter,
      allecordsRouter: allecordsRouter,
			betweenBuilder: betweenBuilder,
      allecordsBuilder: allecordsBuilder
		)
		let homeTabNavController = UINavigationController(rootViewController: homeTabController)
		homeTabNavController.isNavigationBarHidden = true
		homeTabNavController.interactivePopGestureRecognizer?.isEnabled = true
		homeTabRouter.viewController = homeTabNavController
    betweenRouter.viewController = homeTabNavController
    allecordsRouter.viewController = homeTabNavController
		return homeTabNavController
	}
}
