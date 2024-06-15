//
//  LicenseBuilder.swift
//  Allecords
//
//  Created by 이숲 on 6/12/24.
//

import UIKit

protocol MyPageLicenseProtocol {
  func build(router: MyPageTabRouter) -> UIViewController
}

struct LicenseBuilder: MyPageLicenseProtocol {
  func build(router: MyPageTabRouter) -> UIViewController {
    let licenseRouter = LicenseRouter()
    let licenseViewController = LicenseViewController(router: licenseRouter)
    licenseRouter.viewController = router.viewController
    return licenseViewController
  }
}
