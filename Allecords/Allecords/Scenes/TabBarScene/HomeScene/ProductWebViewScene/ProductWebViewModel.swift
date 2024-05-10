//
//  ProductWebViewModel.swift
//  Allecords
//
//  Created by 이숲 on 5/10/24.
//

import Combine

protocol ProductWebViewModelable: ViewModelable 
where Input == ProductWebInput,
      State == ProductWebState,
      Output == AnyPublisher<State, Never> { }

final class ProductWebViewModel {

}

extension ProductWebViewModel: ProductWebViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany<Output>(
      // TODO: Output 퍼블러셔를 나열합니다.
    ).eraseToAnyPublisher()
  }
}

private extension ProductWebViewModel {
  // TODO: Input을 Output으로 변환하는 메서드를 작성합니다.
}