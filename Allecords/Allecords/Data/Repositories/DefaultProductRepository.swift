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
			"prMember": [
				"title": product.title,
				"price": product.price,
				"description": product.productDetail
			],
			"images": product.images
		]
		let bodyData = try createMultipartFormData(parameters: parameters, boundary: boundary)
		
		var builder = URLRequestBuilder(url: Constant.baseUrl)
		builder.setMethod(.post)
		builder.addHeader(field: "Content-Type", value: "multipart/form-data; boundary=\(boundary)")
		builder.setBody(bodyData)
		
		let service = NetworkService(customSession: session, urlRequestBuilder: builder)
		try await service.request()
	}
}

fileprivate extension DefaultProductRepository {
	func createMultipartFormData(parameters: [String: Any], boundary: String) throws -> Data {
		var body = Data()
		let boundaryPrefix = "--\(boundary)\r\n"
		
		for (key, value) in parameters {
			if let array = value as? [Data] {
				for (index, element) in array.enumerated() {
					body.appendString(boundaryPrefix)
					body.appendString("Content-Disposition: form-data; name=\"images\"; filename=\"image\(index).jpg\"\r\n")
					body.appendString("Content-Type: image/jpeg\r\n\r\n")
					body.append(element)
					body.appendString("\r\n")
				}
			} else if let dict = value as? [String: Any] {
				let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
				if let jsonString = String(data: jsonData, encoding: .utf8) {
					body.appendString(boundaryPrefix)
					body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n")
					body.appendString("Content-Type: application/json\r\n\r\n")
					body.appendString(jsonString)
					body.appendString("\r\n")
				}
			} else if let stringValue = value as? String {
				body.appendString(boundaryPrefix)
				body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
				body.appendString("\(stringValue)\r\n")
			} else if let intValue = value as? Int {
				body.appendString(boundaryPrefix)
				body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
				body.appendString("\(intValue)\r\n")
			}
		}
		body.appendString("--\(boundary)--\r\n")
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
