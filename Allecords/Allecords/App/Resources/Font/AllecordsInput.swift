//
//  AllecordsAction.swift
//  Allecords
//
//  Created by 이숲 on 5/7/24.
//

import Combine

struct AllecordsInput {
  let viewLoad: PassthroughSubject<Int, Never>
}

enum AllecordsState {
  case none
  case load(_ products: [AllecordsProduct])
  case error(_ error: Error)
}
