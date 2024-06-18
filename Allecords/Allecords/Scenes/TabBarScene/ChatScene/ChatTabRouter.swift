//
//  ChatTabRouter.swift
//  Allecords
//
//  Created by 이숲 on 6/17/24.
//

import UIKit

final class ChatTabRouter {
	weak var viewController: UINavigationController?
  private var chatDetailBuilder: ChatDetailBuilder
  
	init(chatDetailBuilder: ChatDetailBuilder) {
		self.chatDetailBuilder = chatDetailBuilder
  }
}

// MARK: - RoutingLogic
extension ChatTabRouter: ChatTabRoutingLogic {
  func showChatList() {
    debugPrint("Show Chat View")
  }
  
  func showSearch() {
    debugPrint("Show Search View")
  }
  
  func showAlarm() {
    debugPrint("Show Alarm View")
  }
	
	func showChatDetail(with id: Int) {
		let chatDetailViewController = chatDetailBuilder.build(router: self, id: id)
		viewController?.pushViewController(chatDetailViewController, animated: true)
	}
}
