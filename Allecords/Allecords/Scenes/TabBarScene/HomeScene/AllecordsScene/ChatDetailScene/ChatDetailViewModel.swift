//
//  ChatDetailViewModel.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Combine
import Foundation

protocol ChatDetailViewModelable: ViewModelable
where Input == ChatDetailInput,
State == ChatDetailState,
Output == AnyPublisher<State, Never> { }

protocol ChatDetailDataSource {
	var webSocketUrl: URL? { get }
}

final class ChatDetailViewModel {
	private var id: Int
	private let chatUseCase: ChatUseCase
	
	init(
		id: Int,
		chatUseCase: ChatUseCase
	) {
		self.id = id
		self.chatUseCase = chatUseCase
	}
}

extension ChatDetailViewModel: ChatDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany<Output>(
			updateTitle(input)
    ).eraseToAnyPublisher()
  }
}

private extension ChatDetailViewModel {
	func updateTitle(_ input: Input) -> Output {
		return input.viewLoad
			.withUnretained(self)
			.flatMap { (owner, _) -> AnyPublisher<Result<[Chat], Error>, Never> in
				let future = Future(asyncFunc: {
					try await owner.chatUseCase.fetchAllChat(with: owner.id)
				})
				return future.eraseToAnyPublisher()
			}
			.map { result in
				switch result {
				case let .success(chat):
					return .viewLoad(chat)
				case let .failure(error):
					return .error(error)
				}
			}.eraseToAnyPublisher()
	}
}

extension ChatDetailViewModel: ChatDetailDataSource {
	var webSocketUrl: URL? {
		URL(string: "ws://")
	}
}
