//
//  ChatDetailBuilder.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import UIKit

protocol ChatDetailProtocol {
	func build(router: ProductDetailRouter) -> UIViewController
}

struct ChatDetailBuilder: ChatDetailProtocol {
	func build(router: ProductDetailRouter) -> UIViewController {
		let chatDetailRouter = ChatDetailRouter()
		let chatUseCase = DefaultChatUseCase()
		// 임시 아이디
		let id = 10000
		
		let viewModel = ChatDetailViewModel(
			id: id, chatUseCase: chatUseCase
		)
		let chatDetailViewController = ChatDetailViewController(
			router: chatDetailRouter,
			viewModel: viewModel
		)
		chatDetailRouter.viewController = router.viewController
		return chatDetailViewController
	}
}
