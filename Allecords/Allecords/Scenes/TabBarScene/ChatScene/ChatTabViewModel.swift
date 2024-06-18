//
//  ChatTabViewModel.swift
//  Allecords
//
//  Created by 이숲 on 6/17/24.
//

import Combine
import Foundation

protocol ChatTabViewModelable: ViewModelable
where Input == ChatTabInput,
State == ChatTabState,
Output == AnyPublisher<State, Never> { }

final class ChatTabViewModel {
  private let chatUseCase: ChatUseCase
  
  init(chatUseCase: ChatUseCase) {
    self.chatUseCase = chatUseCase
  }
}

extension ChatTabViewModel: ChatTabViewModelable {
  func transform(_ input: Input) -> Output {
    let viewLoad = viewLoad(input)
    return Publishers.MergeMany(
      viewLoad
    ).eraseToAnyPublisher()
  }
}

private extension ChatTabViewModel {
  func viewLoad(_ input: Input) -> Output {
    return input.viewLoad
      .withUnretained(self)
      .flatMap { (owner, _) -> AnyPublisher<Result<[ChatList], Error>, Never> in
        let future = Future(asyncFunc: {
          await owner.chatUseCase.fetchChatList()
        })
        return future.eraseToAnyPublisher()
      }
      .map { result in
        switch result {
        case let .success(chatList):
          return .load(chatList)
        case let .failure(error):
          return .error(error)
        }
      }.eraseToAnyPublisher()
  }
}
