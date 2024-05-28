//
//  AddViewModel.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Combine
import Foundation

protocol AddViewModelable: ViewModelable
where Input == AddInput,
State == AddState,
Output == AnyPublisher<State, Never> { }

final class AddViewModel {
	private let productUseCase: ProductUseCase
	
	private var productName: String = ""
	private var productPrice: UInt = 0
	private var productDetail: String = ""
	private var images: [Data] = []
	
	init(productUseCase: ProductUseCase) {
		self.productUseCase = productUseCase
	}
}

extension AddViewModel: AddViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany([
			productNameChanged(input),
			priceChanged(input),
			productDetailChanged(input),
			imageAdded(input),
			confirmButtonTapped(input)
    ]).eraseToAnyPublisher()
  }
}

private extension AddViewModel {
	func productNameChanged(_ input: Input) -> Output {
		return input.productNameChanged
			.withUnretained(self)
			.map { owner, value in
				owner.productName = value
				return .none
			}
			.eraseToAnyPublisher()
	}
	
	func priceChanged(_ input: Input) -> Output {
		return input.priceChanged
			.withUnretained(self)
			.map { owner, value in
				if let price = UInt(value) {
					owner.productPrice = price
					return .none
				} else {
					return .invalidPrice
				}
			}
			.eraseToAnyPublisher()
	}
	
	func productDetailChanged(_ input: Input) -> Output {
		return input.productDetailChanges
			.withUnretained(self)
			.map { owner, value in
				owner.productDetail = value
				return .none
			}
			.eraseToAnyPublisher()
	}
	
	func imageAdded(_ input: Input) -> Output {
		return input.imageAdded
			.withUnretained(self)
			.map { owner, value in
				owner.images = value
				return .none
			}
			.eraseToAnyPublisher()
	}
	
	func confirmButtonTapped(_ input: Input) -> Output {
		return input.confirmButtonTapped
			.withUnretained(self)
			.flatMap { (owner, _) in
				return Future(asyncFunc: {
					await owner.productUseCase.registerProducts(
						with: ProductRegister(
							title: owner.productName,
							price: owner.productPrice,
							productDetail: owner.productDetail,
							images: owner.images
						)
					)
				}).eraseToAnyPublisher()
			}
			.map { result in
				switch result {
				case .success:
					return .success
				case let .failure(error):
					return .error(error)
				}
			}
			.eraseToAnyPublisher()
	}
}
