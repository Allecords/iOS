//
//  SceneDelegate.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	var appRouter: AppRouterProtocol?

	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		guard window != nil else { return }
		let dependencies = DependenciesAllocator.allocate()
		window!.makeKeyAndVisible()
		appRouter = AppRouter(window: window!, tabBarBuilder: TabBarBuilder())
		appRouter?.showTapFlow()
//		appCoordinator?.start()
	}

}

