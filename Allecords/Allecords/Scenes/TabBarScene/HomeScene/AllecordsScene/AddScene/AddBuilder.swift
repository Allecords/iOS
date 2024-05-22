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
		let router = AddRouter()
		let viewModel = AddViewModel()
		let addViewController = AddViewController(
			router: router,
			viewModel: viewModel
		)
		return addViewController
	}
}
