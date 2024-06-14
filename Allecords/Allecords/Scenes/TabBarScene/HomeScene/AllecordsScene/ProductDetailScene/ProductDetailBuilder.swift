//
//  ProductDetailBuilder.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import AllecordsNetwork
import UIKit

protocol BetweenProductDetailBuilderProtocol {
	func build(router: BetweenRouter, product: BetweenProduct) -> UIViewController
}

protocol AllecordsProductDetailBuilderProtocol {
  func build(router: AllecordsRouter, product: AllecordsProduct) -> UIViewController
}

struct ProductDetailBuilder: AllecordsProductDetailBuilderProtocol {
  func build(router: AllecordsRouter, product: AllecordsProduct) -> UIViewController {
    let session = CustomSession()
    let productDetailRouter = ProductDetailRouter()
    
    let homeRepository = DefaultHomeRepository(session: session)
    let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
    let productDetailViewModel = ProductDetailViewModel(homeUseCase: homeUseCase, product: product)
    let productDetailViewController = ProductDetailViewController(
      router: productDetailRouter,
      viewModel: productDetailViewModel
    )
    productDetailRouter.viewController = router.viewController
    return productDetailViewController
  }
}
