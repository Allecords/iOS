//
//  ChatTabAction.swift
//  Allecords
//
//  Created by 이숲 on 6/17/24.
//

import Combine

struct ChatTabInput {
  let viewLoad: PassthroughSubject<Void, Never>
}

enum ChatTabState {
  case none
  case load(_ chatList: [ChatList])
  case error(_ error: Error)
}
