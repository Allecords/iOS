//
//  MyPageTabViewModel.swift
//  Allecords
//
//  Created by 이숲 on 5/29/24.
//

import Combine
import Foundation

protocol MyPageTabViewModelable: ViewModelable
where Input == MyPageTabInput,
State == MyPageTabState,
Output == AnyPublisher<State, Never> { }

final class MyPageTabViewModel {
  private let myPageUseCase: MyPageUseCase
  
  private var toggleOn: Bool = false
  
  init(myPageUseCase: MyPageUseCase) {
    self.myPageUseCase = myPageUseCase
  }
}

extension MyPageTabViewModel: MyPageTabViewModelable {
  func transform(_ input: MyPageTabInput) -> Output {
    let alarmToggleChanged = alarmToggleChanged(input)
    let labelTapped = labelTapped(input)
    return Publishers.MergeMany(
      alarmToggleChanged,
      labelTapped
    ).eraseToAnyPublisher()
  }
}

private extension MyPageTabViewModel {
  func alarmToggleChanged(_ input: Input) -> Output {
    return input.alarmToggleChanged
      .withUnretained(self)
      .map { (owner, isOn) in
        owner.myPageUseCase.updateNotificationSettings(isOn: isOn)
        return.success
      }.eraseToAnyPublisher()
  }
  
  func labelTapped(_ input: Input) -> Output {
    return input.labelTapped
      .withUnretained(self)
      .map { (owner, label) in
        switch label {
        case "logout":
          owner.myPageUseCase.logout()
          return .none
        case "signout":
          owner.myPageUseCase.signout()
          return .none
        default:
          return .none
        }
      }
      .eraseToAnyPublisher()
  }
}
