//
//  ChatDetailViewModel.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Combine

protocol ChatDetailViewModelable: ViewModelable 
where Input == ChatDetailInput,
State == ChatDetailState,
Output == AnyPublisher<State, Never> { }

final class ChatDetailViewModel {

}

extension ChatDetailViewModel: ChatDetailViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany<Output>(
    ).eraseToAnyPublisher()
  }
}

private extension ChatDetailViewModel {
}
