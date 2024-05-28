//
//  AddAction.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Foundation
import Combine

struct AddInput {
	let productNameChanged: AnyPublisher<String, Never>
	let priceChanged: AnyPublisher<String, Never>
	let productDetailChanges: AnyPublisher<String, Never>
	let imageAdded: PassthroughSubject<[Data], Never>
	let confirmButtonTapped: AnyPublisher<Void, Never>
}

enum AddState {
	case success
	case invalidPrice
  case none
	case error(_ error: Error)
}
