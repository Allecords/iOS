//
//  HomeUseCase.swift
//  Allecords
//
//  Created by Hoon on 4/12/24.
//

import Foundation

protocol HomeUseCase {
	func fetchCrawlingProducts(with page: Int) async -> Result<[BetweenProduct], Error>
	func fetchAllecordsProducts(with page: Int) async -> Result<[AllecordsProduct], Error>
}

final class DefaultHomeUseCase {
	private let homeRepository: HomeRepository
	
	init(homeRepository: HomeRepository) {
		self.homeRepository = homeRepository
	}
}

extension DefaultHomeUseCase: HomeUseCase {
	func fetchCrawlingProducts(with page: Int) async -> Result<[BetweenProduct], Error> {
		do {
			let items = try await homeRepository.fetchBetweenProductItems(page: page)
			return .success(items)
		} catch {
			return .failure(error)
		}
	}
	
	func fetchAllecordsProducts(with page: Int) async -> Result<[AllecordsProduct], Error> {
		do {
			let items = try await homeRepository.fetchAllecordsProductItems(page: page)
			return .success(items)
		} catch {
			return .failure(error)
		}
	}
}
