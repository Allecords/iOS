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
	// UseCase에서 채팅방 정보 다 가져 오는 로직이 필요함
}

extension ChatDetailViewModel: ChatDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany<Output>(
    ).eraseToAnyPublisher()
  }
}

private extension ChatDetailViewModel {
	func updateTitle(_ input: Input) -> Output {
		return input.viewLoad
			.withUnretained(self)
			.flatMap { (owner, _) -> AnyPublisher<Void, Never> in
				
				return
			}
			.eraseToAnyPublisher()
	}
}

extension ChatDetailViewModel: ChatDetailDataSource {
	var webSocketUrl: URL? {
		URL(string: "ws://")
	}
}
