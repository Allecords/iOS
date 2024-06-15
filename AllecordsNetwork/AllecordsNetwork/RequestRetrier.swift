//
//  RequestRetrier.swift
//  AllecordsNetwork
//
//  Created by Hoon on 3/31/24.
//

import Foundation

public protocol RequestRetrier {
	func shouldRetry(_ request: URLRequest, with error: Error, attempt: Int) -> Bool
	func retry(_ request: URLRequest, with error: Error, attempt: Int) async -> URLRequest?
}
