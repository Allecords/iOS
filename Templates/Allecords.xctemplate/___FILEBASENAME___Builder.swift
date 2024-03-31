//___FILEHEADER___

import UIKit

protocol ___VARIABLE_productName___Protocol {
  func build() -> UIViewController
}

struct ___VARIABLE_productName___Builder: ___VARIABLE_productName___Protocol {
	func build() -> UIViewController {
		// TODO: 의존성 주입
		let viewModel = ___VARIABLE_productName___ViewModel()
		return ___VARIABLE_productName___Controller(viewModel: viewModel)
	}
}
