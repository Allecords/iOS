//
//  TermsOfServiceRouter.swift
//  Allecords
//
//  Created by 이숲 on 6/11/24.
//

import UIKit

final class TermsOfServiceRouter {
  weak var viewController: UINavigationController?
    // 이후에 여기엔 builder 들이 들어가야함
}

// MARK: - RoutingLogic
extension TermsOfServiceRouter: TermsOfServiceRoutingLogic {
  func dismiss() {
    viewController?.popViewController(animated: true)
  }
}
