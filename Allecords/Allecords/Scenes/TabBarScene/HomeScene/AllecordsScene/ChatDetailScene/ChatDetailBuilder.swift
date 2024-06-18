//
//  ChatDetailBuilder.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import AllecordsNetwork
import UIKit

protocol ChatDetailProtocol {
	func build(router: ProductDetailRouter) -> UIViewController
	func build(router: ChatTabRouter, id: Int) -> UIViewController
}

struct ChatDetailBuilder: ChatDetailProtocol {
	func build(router: ProductDetailRouter) -> UIViewController {
		let chatDetailRouter = ChatDetailRouter()
		let session = CustomSession()
		let chatRepository = DefaultChatRepository(session: session)
		let chatUseCase = DefaultChatUseCase(repository: chatRepository)
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
	
	func build(router: ChatTabRouter, id: Int) -> UIViewController {
		let chatDetailRouter = ChatDetailRouter()
		let session = CustomSession()
		let chatRepository = DefaultChatRepository(session: session)
		let chatUseCase = DefaultChatUseCase(repository: chatRepository)
		
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
