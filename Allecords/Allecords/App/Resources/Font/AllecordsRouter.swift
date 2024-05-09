//
//  AllecordsRouter.swift
//  Allecords
//
//  Created by 이숲 on 5/7/24.
//

import UIKit

final class AllecordsRouter {
  weak var viewController: UINavigationController?
  private var productDetailBuilder: ProductDetailBuilderProtocol
  
  init(productDetailBuilder: ProductDetailBuilderProtocol) {
    self.productDetailBuilder = productDetailBuilder
  }
}

extension AllecordsRouter: AllecordsRoutingLogic {
  func showAlarm() {
  }
  
  func showSearch() {
  }
  
  func showDetailScene(_ product: Product) {
    let productDetailViewController = productDetailBuilder.build(router: self, product: product)
    viewController?.pushViewController(productDetailViewController, animated: true)
  }
}
  
