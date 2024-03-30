//
//  RequestInterceptor.swift
//  AllecordsNetwork
//
//  Created by Hoon on 3/31/24.
//

import Foundation

public protocol RequestInterceptor {
	func intercept(_ request: URLRequest) -> URLRequest
}

public final class AuthRequestInterceptor: RequestInterceptor {
	private let token: String
	
	public init(token: String) {
		self.token = token
	}
	
	public func intercept(_ request: URLRequest) -> URLRequest {
		var request = request
		request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
		return request
	}
}
