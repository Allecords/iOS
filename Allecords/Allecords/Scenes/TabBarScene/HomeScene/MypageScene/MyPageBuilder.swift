//
//  MyPageBuilder.swift
//  Allecords
//
//  Created by 이숲 on 4/17/24.
//

import UIKit

protocol MyPageProtocol {
  func build() -> UIViewController
}

struct MyPageBuilder: MyPageProtocol {
	func build() -> UIViewController {
		// TODO: 의존성 주입
		let viewModel = MyPageViewModel()
		return MyPageController(viewModel: viewModel)
	}
}
