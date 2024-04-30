//
//  BetweenRouter.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

final class BetweenRouter {
	weak var viewController: UINavigationController?
	private var productDetailBuilder: ProductDetailBuilderProtocol
	
	init(productDetailBuilder: ProductDetailBuilderProtocol) {
		self.productDetailBuilder = productDetailBuilder
	}
}

extension BetweenRouter: BetweenRoutingLogic {
	func showAlarm() {
	}
	
	func showSearch() {
	}
	
	func showDetailScene(_ product: Product) {
		let productDetailViewController = productDetailBuilder.build(product: product)
		viewController?.pushViewController(productDetailViewController, animated: true)
	}
}
