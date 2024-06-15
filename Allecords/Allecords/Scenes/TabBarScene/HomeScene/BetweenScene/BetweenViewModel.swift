//
//  BetweenViewModel.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine
import Foundation

protocol BetweenViewModelable: ViewModelable
where Input == BetweenInput,
State == BetweenState,
Output == AnyPublisher<State, Never> { }

final class BetweenViewModel {
  private let homeUseCase: HomeUseCase
  
  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }
}

extension BetweenViewModel: BetweenViewModelable {
  func transform(_ input: Input) -> Output {
    let viewLoad = viewLoad(input)
    return Publishers.MergeMany(
      viewLoad
    ).eraseToAnyPublisher()
  }
}

private extension BetweenViewModel {
  func viewLoad(_ input: Input) -> Output {
    return input.viewLoad
      .withUnretained(self)
      .flatMap { (owner, pageNumber) -> AnyPublisher<Result<[Product], Error>, Never> in
        let future = Future(asyncFunc: {
          await owner.homeUseCase.fetchCrawlingProducts(with: pageNumber)
        })
        return future.eraseToAnyPublisher()
      }
      .map { result in
        switch result {
        case let .success(products):
          return .load(products)
        case let .failure(error):
          return .error(error)
        }
      }.eraseToAnyPublisher()
  }
}
