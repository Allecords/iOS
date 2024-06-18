//
//  ChatUseCase.swift
//  Allecords
//
//  Created by Hoon on 6/18/24.
//

import Combine
import Foundation

protocol ChatUseCase {
  func fetchChatList() async -> Result<[ChatList], Error>
  func fetchAllChat(with id: Int) async -> Result<[Chat], Error>
}

final class DefaultChatUseCase {
}

extension DefaultChatUseCase: ChatUseCase {
  func fetchChatList() async -> Result<[ChatList], Error> {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    
    do {
      return .success([
        ChatList(id: 1, sender: "Alice", lastMessage: "See you tomorrow!", lastDate: dateFormatter.date(from: "2023/06/18 15:23")!, stackMessages: 2),
        ChatList(id: 2, sender: "Bob", lastMessage: "Got the report?", lastDate: dateFormatter.date(from: "2023/06/18 14:05")!, stackMessages: 5),
        ChatList(id: 3, sender: "Charlie", lastMessage: "Thanks for the update.", lastDate: dateFormatter.date(from: "2023/06/17 18:42")!, stackMessages: 0),
        ChatList(id: 4, sender: "Diana", lastMessage: "Let's meet at the cafe.", lastDate: dateFormatter.date(from: "2023/06/17 12:30")!, stackMessages: 1),
        ChatList(id: 5, sender: "Edward", lastMessage: "Happy Birthday!", lastDate: dateFormatter.date(from: "2023/06/16 08:15")!, stackMessages: 3)
      ])
    } catch {
      return .failure(error)
    }
  }
  
  func fetchAllChat(with id: Int) async -> Result<[Chat], Error> {
    do {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
      
      return .success([
        Chat(sender: "Alice", receiver: "Bob", content: "Hey Bob, how are you?", time: dateFormatter.date(from: "2023/06/18 09:00")!),
        Chat(sender: "Bob", receiver: "Alice", content: "I'm good, thanks! How about you?", time: dateFormatter.date(from: "2023/06/18 09:01")!),
        Chat(sender: "Alice", receiver: "Bob", content: "I'm doing well, working on the project.", time: dateFormatter.date(from: "2023/06/18 09:05")!),
        Chat(sender: "Bob", receiver: "Alice", content: "That's great! Need any help?", time: dateFormatter.date(from: "2023/06/18 09:10")!),
        Chat(sender: "Alice", receiver: "Bob", content: "Not right now, but I'll let you know if I do.", time: dateFormatter.date(from: "2023/06/18 09:15")!),
        Chat(sender: "Charlie", receiver: "Diana", content: "Hi Diana, are you free for a call?", time: dateFormatter.date(from: "2023/06/18 10:00")!),
        Chat(sender: "Diana", receiver: "Charlie", content: "Sure, give me 10 minutes.", time: dateFormatter.date(from: "2023/06/18 10:02")!),
        Chat(sender: "Charlie", receiver: "Diana", content: "Okay, I'll call you then.", time: dateFormatter.date(from: "2023/06/18 10:05")!),
        Chat(sender: "Edward", receiver: "Alice", content: "Happy Birthday, Alice!", time: dateFormatter.date(from: "2023/06/18 08:00")!),
        Chat(sender: "Alice", receiver: "Edward", content: "Thank you, Edward!", time: dateFormatter.date(from: "2023/06/18 08:05")!)
      ])
    } catch {
      return .failure(error)
    }
  }
}
