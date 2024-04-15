//
//  HomeUseCase.swift
//  Allecords
//
//  Created by Hoon on 4/12/24.
//

import Foundation

protocol HomeUseCase {
	func fetchCrawlingProducts(with page: Int) async -> Result<[Product], Error>
}

final class DefaultHomeUseCase {
	private let homeRepository: HomeRepository
	
	init(homeRepository: HomeRepository) {
		self.homeRepository = homeRepository
	}
}

extension DefaultHomeUseCase: HomeUseCase {
	func fetchCrawlingProducts(with page: Int) async -> Result<[Product], Error> {
		do {
			let items = try await homeRepository.fetchProductItems(page: page)
			return .success(items)
		} catch {
			return .failure(error)
		}
	}
}
