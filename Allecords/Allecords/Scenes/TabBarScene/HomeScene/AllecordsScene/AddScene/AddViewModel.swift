//
//  AddViewModel.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Combine

protocol AddViewModelable: ViewModelable
where Input == AddInput,
State == AddState,
Output == AnyPublisher<State, Never> { }

final class AddViewModel {
}

extension AddViewModel: AddViewModelable {
  func transform(_ input: Input) -> Output {
		let doneButtonTapped = doneButtonTapped(input)
    return Publishers.MergeMany([
			doneButtonTapped
    ]).eraseToAnyPublisher()
  }
}

private extension AddViewModel {
	func doneButtonTapped(_ input: Input) -> Output {
		return input.complete
			.withUnretained(self)
			.map { _ in
				return .none
			}
			.eraseToAnyPublisher()
	}
}
