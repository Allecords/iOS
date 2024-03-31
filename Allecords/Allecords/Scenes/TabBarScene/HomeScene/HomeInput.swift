//
//  HomeInput.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine
import Foundation

struct HomeInput {
	let viewLoad: PassthroughSubject<Void, Never>
}

enum HomeState {
	case none
	case viewLoad
}
