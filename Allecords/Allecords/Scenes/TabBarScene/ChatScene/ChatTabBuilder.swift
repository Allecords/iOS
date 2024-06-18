//
//  ChatTabBuilder.swift
//  Allecords
//
//  Created by 이숲 on 6/17/24.
//

import AllecordsNetwork
import UIKit

protocol ChatTabBuilderProtocol {
  func build() -> UIViewController
}

struct ChatTabBuilder: ChatTabBuilderProtocol {
  func build() -> UIViewController {
    let chatUseCase = DefaultChatUseCase()
    let chatTabRouter = ChatTabRouter()
    let viewModel = ChatTabViewModel(chatUseCase: chatUseCase)
    let chatTabViewController = ChatTabViewController(
      router: chatTabRouter,
      viewModel: viewModel
    )
    let chatTabNavController = UINavigationController(rootViewController: chatTabViewController)
    chatTabNavController.isNavigationBarHidden = true
    chatTabNavController.interactivePopGestureRecognizer?.isEnabled = true
    chatTabRouter.viewController = chatTabNavController
    return chatTabNavController
  }
}
