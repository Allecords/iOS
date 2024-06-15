//
//  ProductDetailViewModel.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import Combine
import Foundation

protocol ProductDetailViewModelable: ViewModelable
where Input == ProductDetailInput,
State == ProductDetailState,
Output == AnyPublisher<State, Never> { }

final class ProductDetailViewModel {
	private let homeUseCase: HomeUseCase
	private let product: Product
		
	init(homeUseCase: HomeUseCase, product: Product) {
		self.homeUseCase = homeUseCase
		self.product = product
	}
}

extension ProductDetailViewModel: ProductDetailViewModelable {
	func transform(_ input: ProductDetailInput) -> AnyPublisher<ProductDetailState, Never> {
		let viewLoad = viewLoad(input)
		return Publishers.MergeMany(
			viewLoad
		).eraseToAnyPublisher()
	}
}

private extension ProductDetailViewModel {
	func viewLoad(_ input: Input) -> Output {
		return input.viewLoad
			.withUnretained(self)
			.map { (owner, _) in
				return .load(owner.product)
			}.eraseToAnyPublisher()
	}
}
