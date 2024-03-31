//
//  HomeBuilder.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import UIKit

protocol HomeBuilderProtocol {
	func build() -> UIViewController
}

struct HomeBuilder: HomeBuilderProtocol {
	func build() -> UIViewController {
		let homeViewModel = HomeViewModel()
		return HomeViewController(viewModel: homeViewModel)
	}
}
