//
//  HomeDetailBuilder.swift
//  Allecords
//
//  Created by 이숲 on 4/15/24.
//

import AllecordsNetwork
import UIKit

protocol HomeDetailProtocol {
  func build(product: Product) -> UIViewController
}

struct HomeDetailBuilder: HomeDetailProtocol {
  func build(product: Product) -> UIViewController {
		let session = CustomSession()
    let homeDetailRepository = DefaultHomeRepository(session: session)
    let homeDetailUseCase = DefaultHomeUseCase(homeRepository: homeDetailRepository)
    let homeDetailViewModel = HomeDetailViewModel(homeDetailUseCase: homeDetailUseCase, product: product)
		return HomeDetailViewController(viewModel: homeDetailViewModel)
	}
}
