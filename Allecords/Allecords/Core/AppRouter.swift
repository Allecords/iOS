//
//  AppRouter.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

protocol AppRouterProtocol {
	func showTapFlow()
	func showLoginFlow()
}

final class AppRouter: AppRouterProtocol {
	
	private var window: UIWindow
	private var tabBarBuilder: TabBarBuilderProtocol
	
	init(
		window: UIWindow,
		tabBarBuilder: TabBarBuilderProtocol
	) {
		self.window = window
		self.tabBarBuilder = tabBarBuilder
	}
	
	func showTapFlow() {
		let tabBarController = TabBarBuilder().build() as! TabBarViewController
		window.rootViewController = tabBarController
	}
	
	func showLoginFlow() {
		// After login
	}

}
