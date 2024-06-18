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

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions:
		UIScene.ConnectionOptions
	) {
		// swiftlint:disable line_length
		KeyChain.shared.create(key: AuthKey.accessToken, token: "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJra3kiLCJpYXQiOjE3MTg3MjMzNjUsImV4cCI6MTcxODc1OTM2NX0.c0oYa7Ub7R-imx58RVahT19FiFN6Yk0p1-vJqZxwBdnPkpiUx2eeHdcATLWTrd6QjJilFk8cxP_5qJaLgSE-Vg")
		// swiftlint:enable line_length
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		guard window != nil else { return }
		window!.makeKeyAndVisible()
		appRouter = AppRouter(window: window!, tabBarBuilder: TabBarBuilder())
		appRouter?.showTapFlow()
	}
}
