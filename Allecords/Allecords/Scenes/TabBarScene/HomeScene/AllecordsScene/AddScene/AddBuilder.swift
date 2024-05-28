//
//  AddBuilder.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import AllecordsNetwork
import UIKit

protocol AddBuilderProtocol {
	func build(router: AllecordsRouter) -> UIViewController
}

struct AddBuilder: AddBuilderProtocol {
	func build(router: AllecordsRouter) -> UIViewController {
		let addRouter = AddRouter()
		let session = CustomSession(interceptor: AccessTokenInterceptor())
		let repository = DefaultProductRepository(session: session)
		let useCase = DefaultProductUseCase(productRepository: repository)
		let viewModel = AddViewModel(productUseCase: useCase)
		let addViewController = AddViewController(
			router: addRouter,
			viewModel: viewModel
		)
		addRouter.viewController = router.viewController
		return addViewController
	}
}
