//
//  AllecordsBuilder.swift
//  Allecords
//
//  Created by 이숲 on 5/7/24.
//

import AllecordsNetwork
import UIKit

protocol AllecordsBuilderProtocol {
  func build(router: AllecordsRouter) -> UIViewController
}

struct AllecordsBuilder: AllecordsBuilderProtocol {
  func build(router: AllecordsRouter) -> UIViewController {
    let session = CustomSession()
    let homeRepository = DefaultHomeRepository(session: session)
    let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
    let allecordsViewModel = AllecordsViewModel(homeUseCase: homeUseCase)
    let allecordsRouter = AllecordsRouter(
			productDetailBuilder: ProductDetailBuilder(),
			addBuilder: AddBuilder()
		)
    let allecordsViewController = AllecordsViewController(router: allecordsRouter, viewModel: allecordsViewModel)
    allecordsRouter.viewController = router.viewController
    return allecordsViewController
  }
}
