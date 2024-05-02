//
//  DefualtHomeRepository.swift
//  Allecords
//
//  Created by Hoon on 4/13/24.
//

import AllecordsNetwork
import Foundation

final class DefaultHomeRepository {
	private let session: CustomSession
	
	init(session: CustomSession) {
		self.session = session
	}
}

extension DefaultHomeRepository: HomeRepository {
	enum Constant {
		static let baseUrl = "https://allecords.shop/api2/products/"
	}
	
	func fetchProductItems(page: Int) async throws -> [Product] {
		var builder = URLRequestBuilder(url: Constant.baseUrl)
		builder.addQuery(parameter: ["page": "\(page)"])
		builder.setMethod(.get)
		builder.addHeader(
			field: "Content-Type",
			value: "application/json"
		)
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		let data = try await service.request()
		let productResponseDTO = try JSONDecoder().decode([ProductResponseDTO].self, from: data)
		let products = productResponseDTO.map {
			Product(
				title: $0.title,
				artist: $0.artist,
				url: $0.url,
				imgUrl: $0.imageURL,
				price: $0.price
			)
		}
		return products
	}
}
