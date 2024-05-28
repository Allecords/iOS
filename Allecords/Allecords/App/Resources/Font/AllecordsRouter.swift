//
//  AllecordsRouter.swift
//  Allecords
//
//  Created by 이숲 on 5/7/24.
//

import UIKit

final class AllecordsRouter {
  weak var viewController: UINavigationController?
  private var productDetailBuilder: AllecordsProductDetailBuilderProtocol
	private var addBuilder: AddBuilderProtocol
  
  init(
		productDetailBuilder: AllecordsProductDetailBuilderProtocol,
		addBuilder: AddBuilderProtocol
	) {
    self.productDetailBuilder = productDetailBuilder
		self.addBuilder = addBuilder
  }
}

extension AllecordsRouter: AllecordsRoutingLogic {
	func showCreateScene() {
		let addViewController = addBuilder.build(router: self)
		viewController?.pushViewController(addViewController, animated: true)
	}
	
  func showAlarm() {
  }
  
  func showSearch() {
  }
  
  func showDetailScene(_ product: AllecordsProduct) {
    let productDetailViewController = productDetailBuilder.build(router: self, product: product)
    viewController?.pushViewController(productDetailViewController, animated: true)
  }
}
  
