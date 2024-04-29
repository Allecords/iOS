//
//  TabBarBuilder.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

protocol TabBarBuilderProtocol {
	func build() -> UITabBarController
}

struct TabBarBuilder: TabBarBuilderProtocol {
	func build() -> UITabBarController {
		let tabBarController = TabBarViewController(homeBuilderable: BetweenBuilder())
		return tabBarController
	}
}
