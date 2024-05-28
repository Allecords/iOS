//
//  DefaultProductRepository.swift
//  Allecords
//
//  Created by Hoon on 5/28/24.
//

import AllecordsNetwork
import Foundation

final class DefaultProductRepository {
	private let session: CustomSession
	
	init(session: CustomSession) {
		self.session = session
	}
}

extension DefaultProductRepository: ProductRepository {
	enum Constant {
		static let baseUrl = "https://allecords.shop/api/v2/pr-members"
	}
	
	func registerProduct(with product: ProductRegister) async throws {
		let boundary = UUID().uuidString
		let parameters: [String: Any] = [
			"title": product.title,
			"price": product.price,
			"description": product.productDetail,
			"images": product.images
		]
		let bodyData = createMultipartFormData(parameters: parameters, boundary: boundary)
		
		var builder = URLRequestBuilder(url: Constant.baseUrl)
		builder.setMethod(.post)
		builder.addHeader(field: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
		builder.setBody(bodyData)
		
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		try await service.request()
	}
}

fileprivate extension DefaultProductRepository {
	func createMultipartFormData(parameters: [String: Any], boundary: String) -> Data {
		var body = Data()
		let boundaryPrefix = "--\(boundary)\r\n"
		
		for (key, value) in parameters {
			if let array = value as? [String] {
				for element in array {
					body.appendString(boundaryPrefix)
					body.appendString("Content-Disposition: form-data; name=\"\(key)[]\"\r\n\r\n")
					body.appendString("\(element)\r\n")
				}
			} else if let value = value as? String {
				body.appendString(boundaryPrefix)
				body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
				body.appendString("\(value)\r\n")
			} else if let value = value as? Int {
				body.appendString(boundaryPrefix)
				body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
				body.appendString("\(value)\r\n")
			}
		}
		body.appendString("--\(boundary)--")
		return body
	}
}

fileprivate extension Data {
	mutating func appendString(_ string: String) {
		if let data = string.data(using: .utf8) {
			append(data)
		}
	}
}
