//
//  AddRouter.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import UIKit

final class AddRouter {
	weak var viewController: UINavigationController?
}

// MARK: - RoutingLogic
extension AddRouter: AddRoutingLogic {
	func dismiss() {
		viewController?.popViewController(animated: true)
	}
}
