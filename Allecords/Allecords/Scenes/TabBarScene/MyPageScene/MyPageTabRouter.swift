//
//  MyPageRouter.swift
//  Allecords
//
//  Created by 이숲 on 5/22/24.
//

import UIKit

final class MyPageTabRouter {
  weak var viewController: UINavigationController?
  private var termsOfServiceBuilder: MyPageTermsOfServiceBuilderProtocol
  private var licenseBuilder: MyPageLicenseProtocol
  
  init(
    termsOfServiceBuilder: MyPageTermsOfServiceBuilderProtocol,
    licenseBuilder: MyPageLicenseProtocol
  ) {
    self.termsOfServiceBuilder = termsOfServiceBuilder
    self.licenseBuilder = licenseBuilder
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
  
  func showTermsOfServiceScene() {
    let termsOfServiceViewController = termsOfServiceBuilder.build(router: self)
    viewController?.pushViewController(termsOfServiceViewController, animated: true)
  }
  
  func showLicenseScene() {
    let licenseViewController = licenseBuilder.build(router: self)
    viewController?.pushViewController(licenseViewController, animated: true)
  }
}
