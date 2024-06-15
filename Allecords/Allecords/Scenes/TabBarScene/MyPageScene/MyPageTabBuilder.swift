//
//  MyPageBuilder.swift
//  Allecords
//
//  Created by 이숲 on 5/22/24.
//

import AllecordsNetwork
import UIKit

protocol MyPageTabBuilderProtocol {
  func build() -> UIViewController
}

struct MyPageTabBuilder: MyPageTabBuilderProtocol {
  func build() -> UIViewController {
    let myPageUseCase = DefaultMyPageUseCase()
    let myPageTabRouter = MyPageTabRouter(
      termsOfServiceBuilder: TermsOfServiceBuilder(),
      licenseBuilder: LicenseBuilder()
    )
    let viewModel = MyPageTabViewModel(myPageUseCase: myPageUseCase)
    let myPageTabViewController = MyPageTabViewController(
      router: myPageTabRouter,
      viewModel: viewModel
    )
    let myPageTabNavController = UINavigationController(rootViewController: myPageTabViewController)
    myPageTabNavController.isNavigationBarHidden = true
    myPageTabNavController.interactivePopGestureRecognizer?.isEnabled = true
    myPageTabRouter.viewController = myPageTabNavController
    return myPageTabNavController
  }
}
