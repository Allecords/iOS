//
//  ProductRepository.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import Foundation

protocol ProductRepository {
	func registerProduct(with product: ProductRegister) async throws
}
