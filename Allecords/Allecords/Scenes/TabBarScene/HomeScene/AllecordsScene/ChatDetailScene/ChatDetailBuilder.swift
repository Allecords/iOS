//
//  ChatDetailBuilder.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import UIKit

protocol ChatDetailProtocol {
	func build(router: ChatDetailRouteProtocol) -> UIViewController
}

struct ChatDetailBuilder: ChatDetailProtocol {
	func build(router: ChatDetailRouteProtocol) -> UIViewController {
		
		let chatDetailRouter = ChatDetailRouter()
		
		let viewModel = ChatDetailViewModel()
		return ChatDetailViewController(
			router: chatDetailRouter,
			viewModel: viewModel
		)
	}
}
