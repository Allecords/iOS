//
//  TermsOfServiceBuilder.swift
//  Allecords
//
//  Created by 이숲 on 6/11/24.
//

import AllecordsNetwork
import UIKit

protocol MyPageTermsOfServiceBuilderProtocol {
  func build(router: MyPageTabRouter) -> UIViewController
}

struct TermsOfServiceBuilder: MyPageTermsOfServiceBuilderProtocol {
  func build(router: MyPageTabRouter) -> UIViewController {
    let termsOfServiceRouter = TermsOfServiceRouter()
    let termsOfServiceViewController = TermsOfServiceViewController(router: termsOfServiceRouter)
    termsOfServiceRouter.viewController = router.viewController
    return termsOfServiceViewController
  }
}
