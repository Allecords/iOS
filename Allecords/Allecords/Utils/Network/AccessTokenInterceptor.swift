//
//  AccessTokenInterceptor.swift
//  Allecords
//
//  Created by Hoon on 5/29/24.
//

import AllecordsNetwork
import Foundation

struct AccessTokenInterceptor: RequestInterceptor {
	func intercept(_ request: URLRequest) -> URLRequest {
		var request = request
		
		if let accessToken = KeyChain.shared.read(key: AuthKey.accessToken) {
			request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
			return request
		} else {
			return request
		}
	}
}
