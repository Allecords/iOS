//
//  ProductWebRouter.swift
//  Allecords
//
//  Created by 이숲 on 5/10/24.
//

import UIKit

final class ProductWebRouter {
  weak var viewController: UINavigationController?
}

// MARK: - RoutingLogic
extension ProductWebRouter: ProductWebRoutingLogic {
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
