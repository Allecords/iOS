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
		KeyChain.shared.create(key: AuthKey.accessToken, token: "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MTIzNDUiLCJpYXQiOjE3MTY5MTI2OTksImV4cCI6MTcxNjk0ODY5OX0.Q0fi_HS6clKHXtf4gnVYilErMRfbJbegWi2zpFwMjIeNSssT9EThWqYqGw316XqWM0wM1EPwuRArjCbsX45Ogg")
		// swiftlint:enable line_length
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		guard window != nil else { return }
		window!.makeKeyAndVisible()
		appRouter = AppRouter(window: window!, tabBarBuilder: TabBarBuilder())
		appRouter?.showTapFlow()
	}
}
