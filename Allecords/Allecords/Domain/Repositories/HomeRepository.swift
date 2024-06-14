//
//  HomeRepository.swift
//  Allecords
//
//  Created by Hoon on 4/12/24.
//

import Foundation

protocol HomeRepository {
	func fetchBetweenProductItems(page: Int) async throws -> [BetweenProduct]
	func fetchAllecordsProductItems(page: Int) async throws -> [AllecordsProduct]
}
