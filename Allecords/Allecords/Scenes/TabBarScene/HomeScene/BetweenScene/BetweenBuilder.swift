//
//  BetweenBuilder.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import AllecordsNetwork
import UIKit

protocol BetweenBuilderProtocol {
	func build() -> UIViewController
}

struct BetweenBuilder: BetweenBuilderProtocol {
	func build() -> UIViewController {
		let session = CustomSession()
		let homeRepository = DefaultHomeRepository(session: session)
		let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
		let homeViewModel = BetweenViewModel(homeUseCase: homeUseCase)
		return BetweenViewController(viewModel: homeViewModel)
	}
}
