//
//  HomeTabRouter.swift
//  Allecords
//
//  Created by Hoon on 4/30/24.
//

import UIKit

final class HomeTabRouter {
	weak var viewController: UIViewController?
	/// alram, search builder 프로퍼티
	
	init(
	) {
	}
}

extension HomeTabRouter: HomeTabRoutingLogic {
	func showAlarm() {
		debugPrint("Show Alram View")
	}
	
	func showSearch() {
		debugPrint("Show Search View")
	}
}
