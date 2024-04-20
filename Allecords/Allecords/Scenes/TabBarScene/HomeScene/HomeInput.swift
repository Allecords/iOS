//
//  HomeInput.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine

struct HomeInput {
  let viewLoad: PassthroughSubject<Int, Never>
}

enum HomeState {
  case none
  case load(_ products: [Product])
  case error(_ error: Error)
}
