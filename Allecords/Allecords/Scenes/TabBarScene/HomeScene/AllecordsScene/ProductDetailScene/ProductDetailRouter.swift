//
//  ProductDetailRouter.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import UIKit

protocol ChatDetailRouteProtocol {}

final class ProductDetailRouter: ChatDetailRouteProtocol {
  weak var viewController: UINavigationController?
	private var chatDetailBuilder: ChatDetailBuilder
	
	init(chatDetailBuilder: ChatDetailBuilder) {
		self.chatDetailBuilder = chatDetailBuilder
	}
}

// MARK: - RoutingLogic
extension ProductDetailRouter: ProductDetailRoutingLogic {
	func showAlarm() {
	}
	
	func showSearch() {
	}
	
	func enterChat() {
		let chatDetailViewController = chatDetailBuilder.build(router: self)
		viewController?.pushViewController(chatDetailViewController, animated: true)
	}
	
	func dismiss() {
		viewController?.popViewController(animated: true)
	}
}
