//
//  HomeViewModel.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine
import Foundation

protocol HomeViewModelable: ViewModelable
where Input == HomeInput,
State == HomeState,
Output == AnyPublisher<State, Never> { }

final class HomeViewModel {
}

extension HomeViewModel: HomeViewModelable {
	func transform(_ input: Input) -> Output {
		let viewLoad = viewLoad(input)
		return Publishers.MergeMany(
			viewLoad
		).eraseToAnyPublisher()
	}
}

private extension HomeViewModel {
	func viewLoad(_ input: Input) -> Output {
		return input.viewLoad
			.withUnretained(self)
			.map { (owner, _) in
				return .none
			}.eraseToAnyPublisher()
	}
}
