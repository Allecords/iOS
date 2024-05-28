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
		KeyChain.shared.create(key: AuthKey.accessToken, token: "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJ0ZXN0MTIzNDUiLCJpYXQiOjE3MTY5MDkyODMsImV4cCI6MTcxNjk0NTI4M30.XD9J1j97CpTZRHRIkQA3g7R8WJ9dCnOd4ck34V7glU06LTGIabW-AufxTD1lvwHFbTUVhGl5mjv9TlFNlsrpOg")
		// swiftlint:enable line_length
		guard let windowScene = (scene as? UIWindowScene) else { return }
		window = UIWindow(windowScene: windowScene)
		guard window != nil else { return }
		window!.makeKeyAndVisible()
		appRouter = AppRouter(window: window!, tabBarBuilder: TabBarBuilder())
		appRouter?.showTapFlow()
	}
}
