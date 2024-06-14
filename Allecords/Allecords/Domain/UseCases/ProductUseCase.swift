//
//  ProductUseCase.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import Foundation

protocol ProductUseCase {
	func registerProducts(with product: ProductRegister) async -> Result<Void, Error>
}

final class DefaultProductUseCase {
	private let productRepository: ProductRepository
	
	init(productRepository: ProductRepository) {
		self.productRepository = productRepository
	}
}

extension DefaultProductUseCase: ProductUseCase {
	func registerProducts(with product: ProductRegister) async -> Result<Void, Error> {
		do {
			try await productRepository.registerProduct(with: product)
			return .success(())
		} catch {
			return .failure(error)
		}
	}
}
