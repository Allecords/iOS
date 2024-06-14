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
		static let crawledUrl = "https://allecords.shop/api/v2/products"
		static let allecordUrl = "https://allecords.shop/api/v2/pr-members"
	}
	
	func fetchBetweenProductItems(page: Int) async throws -> [BetweenProduct] {
		var builder = URLRequestBuilder(url: Constant.crawledUrl)
		builder.addQuery(parameter: ["page": "\(page)"])
		builder.setMethod(.get)
		builder.addHeader(
			field: "Content-Type",
			value: "application/json"
		)
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		let data = try await service.request()
		let productResponseDTO = try JSONDecoder().decode([BetweenProductResponseDTO].self, from: data)
		let products = productResponseDTO.map {
			BetweenProduct(
				title: $0.title,
				artist: $0.artist,
				url: $0.url,
				imgUrl: $0.imageURL,
				price: $0.price
			)
		}
		return products
	}
	
	func fetchAllecordsProductItems(page: Int) async throws -> [AllecordsProduct] {
		var builder = URLRequestBuilder(url: Constant.allecordUrl)
		builder.addQuery(parameter: ["page": "\(page)"])
		builder.setMethod(.get)
		builder.addHeader(
			field: "Content-Type",
			value: "application/json"
		)
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		let data = try await service.request()
		let productResponseDTO = try JSONDecoder().decode([AllecordsProductDTO].self, from: data)
		let products = productResponseDTO.map {
			AllecordsProduct(
				id: $0.id,
				memberID: $0.memberID,
				title: $0.title,
				description: $0.description,
				url: $0.url,
				price: $0.price,
				active: $0.active,
				images: $0.images
			)
		}
		return products
	}
}
