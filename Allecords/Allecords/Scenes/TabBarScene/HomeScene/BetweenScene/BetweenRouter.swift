//
//  BetweenRouter.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

final class BetweenRouter {
	weak var viewController: UINavigationController?
	private var productDetailBuilder: BetweenProductDetailBuilderProtocol
	
	init(productDetailBuilder: BetweenProductDetailBuilderProtocol) {
		self.productDetailBuilder = productDetailBuilder
	}
}

extension BetweenRouter: BetweenRoutingLogic {
	func showAlarm() {
	}
	
	func showSearch() {
	}
	
	func showDetailScene(_ product: Product) {
		let productDetailViewController = productDetailBuilder.build(router: self, product: product)
		viewController?.pushViewController(productDetailViewController, animated: true)
	}
  
  func showWebViewScene(url: URL) {
    let productWebRouter = ProductWebRouter()
    let productWebViewController = ProductWebViewController(router: productWebRouter, productURL: url)
      productWebRouter.viewController = viewController
      viewController?.pushViewController(productWebViewController, animated: true)
    }
}
