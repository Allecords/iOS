//
//  ProductDetailAction.swift
//  Allecords
//
//  Created by 이숲 on 4/20/24.
//

import Combine

struct ProductDetailInput {
	let viewLoad: PassthroughSubject<Void, Never>
}

enum ProductDetailState {
	case none
	case load(_ product: Product)
	case error(_ error: Error)
}
