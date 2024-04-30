//
//  ProductDetailBuilder.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import AllecordsNetwork
import UIKit

protocol ProductDetailBuilderProtocol {
	func build(router: BetweenRouter, product: Product) -> UIViewController
}

struct ProductDetailBuilder: ProductDetailBuilderProtocol {
	func build(router: BetweenRouter, product: Product) -> UIViewController {
    let session = CustomSession()
		let productDetailRouter = ProductDetailRouter()
		
    let productDetailRepository = DefaultHomeRepository(session: session)
    let productDetailUseCase = DefaultHomeUseCase(homeRepository: productDetailRepository)
    let productDetailViewModel = ProductDetailViewModel(productDetailUseCase: productDetailUseCase, product: product)
		let productDetailViewController = ProductDetailViewController(
			router: productDetailRouter,
			viewModel: productDetailViewModel
		)
		productDetailRouter.viewController = router.viewController
    return productDetailViewController
  }
}
