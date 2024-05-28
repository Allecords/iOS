//
//  AddAction.swift
//  Allecords
//
//  Created by Hoon on 5/22/24.
//

import Combine

struct AddInput {
	let complete: AnyPublisher<Void, Never>
}

enum AddState {
  case none
	case error(_ error: Error)
}
