//
//  HomeRepository.swift
//  Allecords
//
//  Created by Hoon on 4/12/24.
//

import Foundation

protocol HomeRepository {
	func fetchProductItems(page: Int) async throws -> [Product]
}
