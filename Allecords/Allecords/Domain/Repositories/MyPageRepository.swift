//
//  MyPageRepository.swift
//  Allecords
//
//  Created by 이숲 on 6/1/24.
//

import Foundation

protocol MyPageRepository {
  func toggleAlarm(isOn: Bool) throws
  func logout() throws
  func signout() throws
}
