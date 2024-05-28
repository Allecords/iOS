//
//  MyPageRouter.swift
//  Allecords
//
//  Created by 이숲 on 5/22/24.
//

import UIKit

final class MyPageTabRouter {
	weak var viewController: UINavigationController?
  
  init(
  ) {
  }
}

// MARK: - RoutingLogic
extension MyPageTabRouter: MyPageTabRoutingLogic {
  func showMyPage() {
    debugPrint("Show myPage View")
  }
  
  func showAlarm() {
    debugPrint("Show Alram View")
  }
}
