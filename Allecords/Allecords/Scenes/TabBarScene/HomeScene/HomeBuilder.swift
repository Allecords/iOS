//
//  HomeBuilder.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import AllecordsNetwork
import UIKit

protocol HomeBuilderProtocol {
	func build() -> UIViewController
}

struct HomeBuilder: HomeBuilderProtocol {
	func build() -> UIViewController {
		let session = CustomSession()
		let homeRepository = DefaultHomeRepository(session: session)
		let homeUseCase = DefaultHomeUseCase(homeRepository: homeRepository)
		let homeViewModel = HomeViewModel(homeUseCase: homeUseCase)
		return HomeViewController(viewModel: homeViewModel)
	}
}
