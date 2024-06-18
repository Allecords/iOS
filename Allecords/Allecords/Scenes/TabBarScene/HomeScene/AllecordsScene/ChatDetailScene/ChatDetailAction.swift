//
//  ChatDetailAction.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Combine

struct ChatDetailInput {
	let viewLoad: PassthroughSubject<Void, Never>
	let socketConnect: PassthroughSubject<Void, Never>
}

enum ChatDetailState {
  case viewLoad
}
