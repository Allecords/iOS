//
//  MyPageTabInput.swift
//  Allecords
//
//  Created by 이숲 on 5/31/24.
//

import Combine
import Foundation

struct MyPageTabInput {
  let alarmToggleChanged: PassthroughSubject<Bool, Never>
  let labelTapped: PassthroughSubject<String, Never>
}

enum MyPageTabState {
  case success
  case none
  case error(_ error: Error)
}
