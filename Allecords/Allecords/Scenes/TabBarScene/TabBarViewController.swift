//
//  TabBarViewController.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
	private let homeTabBuilder: HomeTabBuilderProtocol
	
	init(homeTabBuilder: HomeTabBuilderProtocol) {
		self.homeTabBuilder = homeTabBuilder
		super.init(nibName: nil, bundle: nil)
	}
	
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Home Tab
		let homeTabViewController = homeTabBuilder.build()
		let homeTabNavigationController = makeTabNavigationController(of: homeTabViewController)
		homeTabNavigationController.tabBarItem = makeTabBarItem(of: .homeTab)
		
		// Chat Tab
		let chatViewController = ChatViewController()
		let chatTabNavigationController = makeTabNavigationController(of: chatViewController)
		chatTabNavigationController.tabBarItem = makeTabBarItem(of: .chatTab)
		
		// MyPage Tab
		let myPageViewController = MyPageViewController()
		let myPageTabNavigationController = makeTabNavigationController(of: myPageViewController)
		myPageTabNavigationController.tabBarItem = makeTabBarItem(of: .myPageTab)
		
		self.viewControllers = [
			homeTabNavigationController,
			chatTabNavigationController,
			myPageTabNavigationController
		]
		selectedIndex = TabBarpage.homeTab.pageorderNumber()
		view.backgroundColor = .background
		tabBar.backgroundColor = .background
		tabBar.tintColor = .primary1
	}
}

private extension TabBarViewController {
	func makeTabNavigationController(of scene: UIViewController) -> UINavigationController {
		let tabNavigationController = UINavigationController(rootViewController: scene)
		tabNavigationController.isNavigationBarHidden = true
		tabNavigationController.interactivePopGestureRecognizer?.isEnabled = true
		return tabNavigationController
	}
	
	func makeTabBarItem(of page: TabBarpage) -> UITabBarItem {
		return UITabBarItem(
			title: page.pageTitleValue(),
			image: .init(systemName: page.tabIconName()),
			tag: page.pageorderNumber()
		)
	}
}
