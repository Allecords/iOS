//
//  LicenseRouter.swift
//  Allecords
//
//  Created by 이숲 on 6/12/24.
//

import UIKit

final class LicenseRouter {
	weak var viewController: UINavigationController?
}

// MARK: - RoutingLogic
extension LicenseRouter: LicenseRoutingLogic {
  func dismiss() {
    viewController?.popViewController(animated: true)
  }
}
