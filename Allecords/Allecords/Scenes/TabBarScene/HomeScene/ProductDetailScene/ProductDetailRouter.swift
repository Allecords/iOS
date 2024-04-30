//
//  ProductDetailRouter.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import UIKit

final class ProductDetailRouter {
  weak var viewController: UINavigationController?
    // 이후에 여기엔 builder 들이 들어가야함
}

// MARK: - RoutingLogic
extension ProductDetailRouter: ProductDetailRoutingLogic {
	func showAlarm() {
	}
	
	func showSearch() {
	}
	
	func enterChat() {
	}
	
	func dismiss() {
		viewController?.popViewController(animated: true)
	}
}
