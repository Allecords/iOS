//
//  AllecordsViewModel.swift
//  Allecords
//
//  Created by 이숲 on 5/7/24.
//

import Combine
import Foundation

protocol AllecordsViewModelable: ViewModelable
where Input == AllecordsInput,
State == AllecordsState,
Output == AnyPublisher<State, Never> { }

final class AllecordsViewModel {
  private let homeUseCase: HomeUseCase
  
  init(homeUseCase: HomeUseCase) {
    self.homeUseCase = homeUseCase
  }
}

extension AllecordsViewModel: AllecordsViewModelable {
  func transform(_ input: Input) -> Output {
    let viewLoad = viewLoad(input)
    return Publishers.MergeMany(
      viewLoad
    ).eraseToAnyPublisher()
  }
}

private extension AllecordsViewModel {
  func viewLoad(_ input: Input) -> Output {
    return input.viewLoad
      .withUnretained(self)
      .flatMap { (owner, pageNumber) -> AnyPublisher<Result<[AllecordsProduct], Error>, Never> in
        let future = Future(asyncFunc: {
          await owner.homeUseCase.fetchAllecordsProducts(with: pageNumber)
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
