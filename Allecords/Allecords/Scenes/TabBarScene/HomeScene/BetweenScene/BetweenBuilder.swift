//
//  BetweenBuilder.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import AllecordsNetwork
import UIKit

protocol BetweenBuilderProtocol {
	func build(router: BetweenRouter) -> UIViewController
}

struct BetweenBuilder: BetweenBuilderProtocol {
	func build(router: BetweenRouter) -> UIViewController {
		let session = CustomSession()
		let homeRepository = DefaultHomeRepository(session: session)
		let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
		let betweenViewModel = BetweenViewModel(homeUseCase: homeUseCase)
		let betweenRouter = BetweenRouter(productDetailBuilder: ProductDetailBuilder())
		let betweenViewController = BetweenViewController(router: betweenRouter, viewModel: betweenViewModel)
		betweenRouter.viewController = router.viewController
		return betweenViewController
	}
}
