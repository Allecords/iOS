//
//  MyPageViewModel.swift
//  Allecords
//
//  Created by 이숲 on 4/17/24.
//

import Combine

protocol MyPageViewModelable: ViewModelable 
where Input == MyPageInput,
      State == MyPageState,
      Output == AnyPublisher<State, Never> { }

final class MyPageViewModel {

}

extension MyPageViewModel: MyPageViewModelable {
  func transform(_ input: Input) -> Output {
    return Publishers.MergeMany<Output>(
      // TODO: Output 퍼블러셔를 나열합니다.
    ).eraseToAnyPublisher()
  }
}

private extension MyPageViewModel {
  // TODO: Input을 Output으로 변환하는 메서드를 작성합니다.
}