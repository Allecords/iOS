//
//  HomeViewModel.swift
//  Allecords
//
//  Created by Hoon on 3/31/24.
//

import Combine
import Foundation

protocol HomeViewModelable: ViewModelable
where Input == HomeInput,
State == HomeState,
Output == AnyPublisher<State, Never> { }

final class HomeViewModel {
  private let homeUseCase: HomeUseCase
  
  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }
}

extension HomeViewModel: HomeViewModelable {
  func transform(_ input: Input) -> Output {
    let viewLoad = viewLoad(input)
    return Publishers.MergeMany(
      viewLoad
    ).eraseToAnyPublisher()
  }
}

private extension HomeViewModel {
  func viewLoad(_ input: Input) -> Output {
    return input.viewLoad
      .withUnretained(self)
      .flatMap { (owner, _) -> AnyPublisher<Result<[Product], Error>, Never> in
        let future = Future(asyncFunc: {
          await owner.homeUseCase.fetchCrawlingProducts(with: 1)
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
