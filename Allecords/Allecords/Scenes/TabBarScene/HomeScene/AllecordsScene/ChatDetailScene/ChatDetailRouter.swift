//
//  ChatDetailRouter.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import UIKit

final class ChatDetailRouter {
	weak var viewController: UINavigationController?
}

// MARK: - RoutingLogic
extension ChatDetailRouter: ChatDetailRoutingLogic {
	func dismissChatScene() {
		viewController?.popViewController(animated: true)
	}
}
