//
//  HomeDetailAction.swift
//  Allecords
//
//  Created by 이숲 on 4/15/24.
//

import Combine

struct HomeDetailInput {
    let viewLoad: PassthroughSubject<Int, Never>
}

enum HomeDetailState {
    case none
    case load(_ product: Product)
    case error(_ error: Error)
}
