//
//  BetweenInput.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine

struct BetweenInput {
	let viewLoad: PassthroughSubject<Int, Never>
}

enum BetweenState {
	case none
	case load(_ products: [Product])
	case error(_ error: Error)
}
