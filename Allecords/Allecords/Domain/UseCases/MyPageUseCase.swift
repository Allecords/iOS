//
//  MyPageUseCase.swift
//  Allecords
//
//  Created by 이숲 on 6/1/24.
//

import Combine
import Foundation
import UserNotifications

protocol MyPageUseCase {
  func updateNotificationSettings(isOn: Bool)
  func logout()
  func signout()
}

final class DefaultMyPageUseCase {
  init() {
  }
}

extension DefaultMyPageUseCase: MyPageUseCase {
  func updateNotificationSettings(isOn: Bool) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      if settings.authorizationStatus == .authorized {
        if isOn {
          center.requestAuthorization(options: [
            .alert,
            .sound,
            .badge
          ]) { granted, _ in
            if granted {
              DispatchQueue.main.async {
                self.scheduleNotifications()
              }
            }
          }
        } else {
          center.removeAllPendingNotificationRequests()
        }
      } else {
        center.requestAuthorization(options: [
          .alert,
          .sound,
          .badge
        ]) { granted, _ in
          if granted {
            DispatchQueue.main.async {
              self.scheduleNotifications()
            }
          }
        }
      }
    }
  }
  
  func logout() {
    debugPrint("logout")
  }
  
  func signout() {
    debugPrint("signout")
  }
}

extension DefaultMyPageUseCase {
  func scheduleNotifications() {
    let content = UNMutableNotificationContent()
    content.title = "알림 제목"
    content.body = "알림 내용"
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
      if let error = error {
        print("Error adding notification: \(error.localizedDescription)")
      }
    }
  }
}
